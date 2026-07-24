extends Area3D

const EXPLOSION_EFFECT = preload("uid://raq4p4c8uiwg")

@onready var grid_pos: Vector3i = Vector3i(position) #idk how grid_pos is gonna matter now but maybe it'll come in use??
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor
@onready var cam: Camera3D = $Anchor/Camera3D
@onready var item_sprite: TileSprite = $Anchor/ItemSprite

var position_tween: Tween
var prev_tile: Tile
var curr_tile: Tile
var curr_flag: Flag
var can_move: bool = false


func _enter_tree() -> void:
	Events.move_missed.connect(_on_move_missed)
	Events.timestep.connect(_on_timestep)
	Events.item_gotten.connect(_on_item_gotten)


func _ready() -> void:
	item_sprite.hide()
	item_sprite.position = Vector3(0.3, 1.4, 0.5)

	await get_tree().physics_frame

	curr_tile = check_tile(grid_pos)
	prev_tile = curr_tile


func move_to_pos(new_pos: Vector3i) -> void:
	# 3. check validity of tile in that direction
	# 4. move player to that tile
	# 5. emit stepped off for previous tile
	# 6. next timestep

	var new_tile := check_tile(new_pos)
	if not new_tile: return

	prev_tile = curr_tile
	curr_tile = new_tile

	# move to new position
	grid_pos = new_pos
	global_position = new_pos
	animate_to_grid_position()

	prev_tile.stepped_off.emit()

	Clock.advance_time()
	tile_sprite.play("default")


func check_tile(pos: Vector3i) -> Tile:
	var areas := shapecast_at_pos(pos)
	if areas.size() == 0: return null
	for area in areas:
		if area is Tile and not area.is_disabled:
			return area

	return null


func check_curr_tile() -> void:
	await get_tree().physics_frame
	var areas := shapecast_at_pos(grid_pos)
	for area in areas:
		if area is Flag:
			curr_flag = area
			area.grab()
		if area is TheHolyLight and curr_flag:
			win()
			Events.win.emit()
		if area is BaseEnemy:
			die()
		if area is TileItem:
			area.collect.emit()


func shapecast_at_pos(pos: Vector3i) -> Array[Area3D]:
	var cast_pos := Vector3(pos) + Vector3(0.5, 0.0, 0.5)
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsPointQueryParameters3D.new()
	query.position = Vector3(cast_pos)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var results := space_state.intersect_point(query)
	var overlapping_areas: Array[Area3D] = []
	for result in results:
		if result.collider is Area3D:
			overlapping_areas.append(result.collider)
	return overlapping_areas


func uh_oh() -> void:
	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")
	print("uh oh")


func fall_down() -> void:
	can_move = false
	print("you died!")


func die() -> void:
	can_move = false
	tile_sprite.play("panic")
	tile_sprite.animation_player.play("panic")
	Events.cam_shake.emit(0.4)

	await get_tree().create_timer(0.5).timeout

	var explosion := EXPLOSION_EFFECT.instantiate()
	anchor.add_child(explosion)
	Events.cam_shake.emit(0.6)

	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	tile_sprite.look_at(cam.global_position)

	var die_tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel()
	die_tween.tween_property(tile_sprite, "global_position:x", 5.0, 2.0).as_relative()
	die_tween.tween_property(tile_sprite, "global_position:y", 5.0, 2.0).as_relative()
	die_tween.tween_property(tile_sprite, "global_rotation_degrees:z", 720.0, 2.0).as_relative()
	print("you died!")


func win() -> void:
	can_move = false
	var fade_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_parallel()
	#tile_sprite.material_override.set_shader_parameter("offset", 0.0)
	fade_tween.tween_property(tile_sprite, "position:y", 3, 1.5).as_relative()
	# fade_tween.tween_property(tile_sprite.material_override, "shader_parameter/offset", 6.0, 1.5)
	fade_tween.chain().tween_property(tile_sprite, "visible", false, 0.0)


func _unhandled_input(event: InputEvent) -> void:
	if can_move:
		if event.is_action_pressed("left"):
			tile_sprite.flip_h = true
			move_to_pos(grid_pos + Vector3i(-1, 0, 0))
		elif event.is_action_pressed("right"):
			tile_sprite.flip_h = false
			move_to_pos(grid_pos + Vector3i(1, 0, 0))
		elif event.is_action_pressed("up"):
			move_to_pos(grid_pos + Vector3i(0, 0, -1))
		elif event.is_action_pressed("down"):
			move_to_pos(grid_pos + Vector3i(0, 0, 1))


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_pos := Vector3(grid_pos) + Vector3(0, 0, 0)
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")


func _on_timestep(curr_timestep: int) -> void:
	if curr_timestep == 0:
		can_move = true
	# 1. check current tile for any items
	# 2. emit stepped on for current tile
	check_curr_tile()
	if curr_flag: curr_flag.change_flag_pos(grid_pos)

	curr_tile.stepped_on.emit()


func _on_move_missed() -> void:
	# 3. emit stepped off for current tile
	# 4. check current tile validity again for uh oh check
	# 5. next timestep
	if curr_tile.is_disabled:
		fall_down()
		return

	curr_tile.stepped_off.emit()

	if curr_tile.is_disabled:
		uh_oh()

	Clock.advance_time()

func _on_item_gotten(_tile_item: TileItem, _item_resource: ItemResource) -> void:
	item_sprite.show()
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
	can_move = false
	tile_sprite.flip_h = false
	tile_sprite.play("item_gotten")
	await get_tree().create_timer(1.0).timeout
	tile_sprite.play("default")
	can_move = true
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
	item_sprite.hide()
