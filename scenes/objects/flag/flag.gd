class_name Flag extends Area3D

var position_tween: Tween
@onready var grid_position: Vector3i = Vector3i(position)
@onready var anchor: Node3D = $Anchor


func grab() -> void:
	monitoring = false
	animate_anchor_raise()


func animate_anchor_raise() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(anchor, "position", anchor.position + Vector3.UP, 0.2)


func change_flag_pos(new_pos: Vector3i) -> void:
	grid_position = new_pos
	global_position = new_pos
	animate_to_grid_position()


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_pos := Vector3(grid_position) + Vector3(0, 0, 0)
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
