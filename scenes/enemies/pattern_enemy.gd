class_name PatternEnemy extends BaseEnemy

@export var pattern: Array[Vector3i] = []

@onready var arrow: Sprite3D = $Arrow
@onready var next_square: Sprite3D = $NextSquare

var position_tween: Tween

func _ready() -> void:
	Events.pre_timestep.connect(_on_timestep)
	arrow.top_level = true
	next_square.top_level = true
	update_arrow(Clock.curr_timestep)


func move_to_pos(new_pos: Vector3i) -> void:
	grid_position = new_pos
	global_position = new_pos
	animate_to_grid_position()


func move(curr_timestep: int) -> void:
	var curr_move := pattern[curr_timestep % pattern.size()]
	if curr_move.x > 0:
		tile_sprite.flip_h = false
	elif curr_move.x < 0:
		tile_sprite.flip_h = true

	move_to_pos(grid_position + curr_move)
	update_arrow(curr_timestep)


func update_arrow(curr_timestep: int) -> void:
	var next_move := pattern[(curr_timestep + 1) % pattern.size()]

	arrow.position = Vector3(grid_position) + Vector3(0.5, 0, 0.5)
	arrow.position += Vector3(next_move * 0.5)
	arrow.rotation.y = atan2(next_move.x, next_move.z) - PI/2
	next_square.position = Vector3(grid_position + next_move) + Vector3(0.5, 0, 0.5)


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_pos := Vector3(grid_position) + Vector3(0, 0, 0)
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")


func _on_timestep(curr_timestep: int) -> void:
	if is_dead: return
	super._on_timestep(curr_timestep)

func die() -> void:
	super.die()

	is_dead = true
	collider.disabled = true
	arrow.hide()
	next_square.hide()
	await get_tree().create_timer(0.2).timeout

	tile_sprite.center()
	tile_sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	tile_sprite.look_at(get_viewport().get_camera_3d().global_position)

	var fall_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_parallel()
	fall_tween.tween_property(tile_sprite, "global_position:y", -10.0, 1.5)
	fall_tween.tween_property(tile_sprite, "global_rotation_degrees:z", 720.0, 1.5)
	fall_tween.tween_property(tile_sprite, "modulate:a", 0.0, 1.0)
	fall_tween.chain().tween_callback(queue_free)
