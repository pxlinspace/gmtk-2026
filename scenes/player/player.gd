extends Node3D

@onready var grid_position: Vector3i = Vector3i(position)
@onready var tile_sprite: TileSprite = $TileSprite


func _unhandled_input(event: InputEvent) -> void:
	var is_movement_input: bool = true
	if event.is_action_pressed("left"):
		grid_position.x -= 1
	elif event.is_action_pressed("right"):
		grid_position.x += 1
	elif event.is_action_pressed("up"):
		grid_position.z -= 1
	elif event.is_action_pressed("down"):
		grid_position.z += 1
	else:
		is_movement_input = false
	
	if is_movement_input:
		animate_to_grid_position()


func animate_to_grid_position() -> void:
	var position_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	position_tween.tween_property(self, "position", Vector3(grid_position), 0.2)
	tile_sprite.animation_player.stop()
	tile_sprite.animation_player.play("bounce")
