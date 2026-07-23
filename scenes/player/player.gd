extends Node3D

@onready var grid_position: Vector3i = Vector3i(position)
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor

var position_tween: Tween


func move_to_pos(new_pos: Vector3i) -> void:
	# check if new position is valid
	var cast_pos := Vector3(new_pos - grid_position) + Vector3(0.5, 0, 0.5)
	var space_state := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = 0.2
	var query := PhysicsShapeQueryParameters3D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.shape = shape
	query.transform = global_transform
	query.transform.origin += Vector3(cast_pos)
	print(query.transform.origin)
	var results := space_state.intersect_shape(query)

	if results.size() == 0: return
	var is_valid := false
	for item in results:
		var collider := item.collider as Object
		if collider is Tile:
			is_valid = true
			break
	if not is_valid: return

	grid_position = new_pos
	global_position = new_pos
	animate_to_grid_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		move_to_pos(grid_position + Vector3i(-1, 0, 0))
	elif event.is_action_pressed("right"):
		move_to_pos(grid_position + Vector3i(1, 0, 0))
	elif event.is_action_pressed("up"):
		move_to_pos(grid_position + Vector3i(0, 0, -1))
	elif event.is_action_pressed("down"):
		move_to_pos(grid_position + Vector3i(0, 0, 1))


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_pos := Vector3(grid_position) + Vector3(0, 0, 0)
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
