extends Area3D

const EXPLOSION_EFFECT = preload("uid://raq4p4c8uiwg")

@export var winning_treasure: SpriteFrames

@onready var grid_pos: Vector3i = Vector3i(position) #idk how grid_pos is gonna matter now but maybe it'll come in use??
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor
@onready var cam: Camera3D = $Anchor/Camera3D
@onready var item_sprite: TileSprite = $Anchor/ItemSprite
@onready var impact_sprite: TileSprite = $Anchor/ImpactSprite

@onready var step_audio: AudioStreamPlayer = $StepAudio
@onready var treasure_found_audio: AudioStreamPlayer = $TreasureFoundAudio
@onready var panic_audio: AudioStreamPlayer = $PanicAudio
@onready var win_audio: AudioStreamPlayer = $WinAudio
@onready var fall_audio: AudioStreamPlayer = $FallAudio
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var hit_audio: AudioStreamPlayer = $HitAudio

var position_tween: Tween
var prev_tile: Tile
var curr_tile: Tile
var can_move: bool = false
var fell_down: bool = false
var curr_dir: Vector3i = Vector3i.ZERO


func _enter_tree() -> void:
	Events.pre_move_missed.connect(_on_pre_move_missed)
	Events.move_missed.connect(_on_move_missed)
	Events.timestep.connect(_on_timestep)
	Events.item_gotten.connect(_on_item_gotten)
	Events.restart_level.connect(_on_restart_level)
	Events.player_pogo.connect(_on_player_pogo)


func _ready() -> void:
	item_sprite.hide()

	await get_tree().process_frame

	curr_tile = check_tile(grid_pos)
	prev_tile = curr_tile

	beamed_down()


func move_to_pos(new_pos: Vector3i, check_valid: bool = true) -> void:
	var new_tile := check_tile(new_pos)
	if not new_tile and check_valid: return
	step_audio.pitch_scale = randf_range(0.9, 1.2)
	step_audio.play()
	prev_tile = curr_tile
	curr_tile = new_tile

	# move to new position
	grid_pos = new_pos
	global_position = new_pos
	animate_to_grid_position()

	if prev_tile:
		prev_tile.stepped_off.emit()

	Clock.advance_time()


func check_tile(pos: Vector3i) -> Tile:
	var areas := Utils.shapecast_at_pos(pos)
	for area in areas:
		if area is Tile and not area.is_disabled:
			return area

	return null


func check_curr_tile() -> void:
	if fell_down:
		return
	var areas := Utils.shapecast_at_pos(grid_pos)
	for area in areas:
		if area is TheHolyLight and area.is_active:
			await win()
			Events.win.emit()
		if area is BaseEnemy:
			die()
		if area is TileItem:
			area.collect.emit()


func uh_oh() -> void:
	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")
	panic_audio.play()
	print("uh oh")


func fall_down() -> void:
	Events.toggle_pause.emit(true)
	Events.player_lost.emit()
	fell_down = true
	can_move = false
	print("you died!")
	fall_audio.play()

	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	tile_sprite.look_at(cam.global_position)
	tile_sprite.center()
	tile_sprite.stop()
	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")
	

	var fall_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_parallel()
	fall_tween.tween_property(tile_sprite, "global_position:y", -10.0, 1.5)
	fall_tween.tween_property(tile_sprite, "global_rotation_degrees:z", 720.0, 1.5).set_trans(Tween.TRANS_LINEAR)
	fall_tween.tween_property(tile_sprite, "modulate:a", 0.0, 1.0)
	
	await get_tree().create_timer(1.0).timeout
	Events.player_gone.emit()


func die() -> void:
	Events.toggle_pause.emit(true)
	Events.player_lost.emit()
	can_move = false
	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")
	impact_sprite.show()
	impact_sprite.play("default")
	Events.cam_shake.emit(0.4)
	
	hit_audio.play()

	await get_tree().create_timer(0.5).timeout

	impact_sprite.hide()
	impact_sprite.stop()
	
	explosion_audio.play()

	var explosion := EXPLOSION_EFFECT.instantiate()
	anchor.add_child(explosion)
	Events.cam_shake.emit(0.6)

	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	tile_sprite.center()
	tile_sprite.look_at(cam.global_position)

	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")

	var die_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel()
	die_tween.tween_property(tile_sprite, "global_position:x", 5.0, 2.5)
	die_tween.tween_property(tile_sprite, "global_position:y", 5.0, 2.5)
	die_tween.tween_property(tile_sprite, "global_rotation_degrees:z", 720.0, 2.0)
	print("you died!")
	await get_tree().create_timer(1).timeout
	Events.player_gone.emit()


func beamed_down() -> void:
	can_move = false
	tile_sprite.position.y = 3
	tile_sprite.scale.y = 4.0
	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	var beam_tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel()
	beam_tween.tween_property(tile_sprite, "position:y", 0.0, 1.0)
	beam_tween.tween_property(tile_sprite, "scale:y", 1.5, 1.0)
	beam_tween.chain().tween_callback(func() -> void:
		can_move = true
		Events.player_beamed_down.emit()
		tile_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		tile_sprite.scale.y = 1.0
		tile_sprite.animation_player.play("bounce_in_place")
	)


func win() -> void:
	Events.player_beamed_up.emit()
	Events.toggle_pause.emit(true)
	win_audio.play()
	can_move = false
	item_sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	#show_item(winning_treasure)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
	tile_sprite.flip_h = false
	tile_sprite.play("item_gotten")
	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	var fade_tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN).set_parallel()
	fade_tween.tween_property(tile_sprite, "position:y", 3, 1.5)
	fade_tween.tween_property(item_sprite, "position:y", 3, 1.5).as_relative()
	fade_tween.tween_property(tile_sprite, "scale:y", 4.0, 1.5)
	fade_tween.tween_property(item_sprite, "scale:y", 4.0, 1.5).as_relative()
	fade_tween.chain().tween_property(tile_sprite, "visible", false, 0.0)
	fade_tween.tween_callback(func() -> void:
		tile_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	)
	await fade_tween.finished


func _unhandled_input(event: InputEvent) -> void:
	if can_move:
		if event.is_action_pressed("speed_up"):
			tile_sprite.animation_player.stop()
			tile_sprite.animation_player.play("bounce_in_place")
		elif event.is_action_pressed("left"):
			tile_sprite.flip_h = true
			curr_dir = Vector3i(-1, 0, 0)
			move_to_pos(grid_pos + curr_dir)
		elif event.is_action_pressed("right"):
			tile_sprite.flip_h = false
			curr_dir = Vector3i(1, 0, 0)
			move_to_pos(grid_pos + curr_dir)
		elif event.is_action_pressed("up"):
			curr_dir = Vector3i(0, 0, -1)
			move_to_pos(grid_pos + curr_dir)
		elif event.is_action_pressed("down"):
			curr_dir = Vector3i(0, 0, 1)
			move_to_pos(grid_pos + curr_dir)


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_pos := Vector3(grid_pos) + Vector3(0, 0, 0)
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")


func show_item(sprite: SpriteFrames) -> void:
	item_sprite.sprite_frames = sprite
	item_sprite.animation_player.stop()
	item_sprite.animation_player.play("bounce")
	item_sprite.show()
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
	tile_sprite.flip_h = false
	tile_sprite.play("item_gotten")
	await Events.timestep
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
	item_sprite.hide()


func _on_timestep(_curr_timestep: int) -> void:
	if can_move:
		tile_sprite.play("default")

	check_curr_tile()

	if not curr_tile:
		print("yeah you just pogoed onto thin air")
		fall_down()
		return

	curr_tile.stepped_on.emit()

	if curr_tile.is_disabled and can_move:
		uh_oh()


func _on_pre_move_missed() -> void:
	if curr_tile.is_disabled:
		fall_down()
		return

	curr_tile.stepped_off.emit()


func _on_move_missed() -> void:
	pass


func _on_item_gotten(tile_item: TileItem) -> void:
	var item_resource := tile_item.item_resource
	var is_treasure := tile_item is TreasureItem
	
	if is_treasure:
		treasure_found_audio.play()

	await show_item(item_resource.sprite_frames)

	if is_treasure:
		Events.treasure_received.emit()
	else:
		Events.item_received.emit(item_resource)


func _on_restart_level() -> void:
	can_move = false


func _on_player_pogo(distance: int) -> void:
	var new_pos := grid_pos + curr_dir * distance
	move_to_pos(new_pos, false)
