extends Node3D

@onready var grid_pos: Vector3i = Vector3i(position) #idk how grid_pos is gonna matter now but maybe it'll come in use??
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor

var position_tween: Tween
var curr_tile: Tile
var curr_flag: Flag


func _ready() -> void:
	Events.move_missed.connect(_on_move_missed)


func move_to_pos(new_pos: Vector3i) -> void:
	var new_tile := check_tile(new_pos)
	if not new_tile:
		if new_pos == grid_pos:
			fall_down()
		return
	else:
		if curr_tile: curr_tile.stepped_off.emit()
		curr_tile = new_tile
		curr_tile.stepped_on.emit()

	# move to new position
	var last_pos := grid_pos
	grid_pos = new_pos
	global_position = new_pos
	animate_to_grid_position()

	check_curr_tile()
	if curr_flag:
		curr_flag.change_flag_pos(new_pos)

	Clock.advance_time()

	var tile := check_tile(new_pos)
	if last_pos == grid_pos and tile.countdown <= 1:
		print("ahhh im falling")


func check_tile(pos: Vector3i) -> Tile:
	var results := shapecast_at_pos(pos - grid_pos)
	if results.size() == 0: return null
	for item in results:
		var collider := item.collider as Object
		if collider is Tile:
			return collider

	return null


func check_curr_tile() -> void:
	var results := shapecast_at_pos(Vector3i.ZERO)
	for item in results:
		var collider := item.collider as Object
		if collider is Flag:
			curr_flag = collider
			collider.grab()
		if collider is TheHolyLight and curr_flag:
			win()
			Events.win.emit()


func shapecast_at_pos(pos: Vector3i) -> Array[Dictionary]:
	var cast_pos := Vector3(pos) + Vector3(0.5, 0, 0.5)
	var space_state := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = 0.2
	var query := PhysicsShapeQueryParameters3D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.shape = shape
	query.transform = global_transform
	query.transform.origin += Vector3(cast_pos)
	return space_state.intersect_shape(query)


func fall_down() -> void:
	print("you died!")


func win() -> void:
	var fade_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_parallel()
	#tile_sprite.material_override.set_shader_parameter("offset", 0.0)
	fade_tween.tween_property(tile_sprite, "position:y", 2, 1.5)
	fade_tween.tween_property(tile_sprite.material_override, "shader_parameter/offset", 6.0, 1.5)
	fade_tween.chain().tween_property(tile_sprite, "visible", false, 0.0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		tile_sprite.flip_h = false
		move_to_pos(grid_pos + Vector3i(-1, 0, 0))
	elif event.is_action_pressed("right"):
		tile_sprite.flip_h = true
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

func _on_move_missed() -> void:
	move_to_pos(grid_pos)
