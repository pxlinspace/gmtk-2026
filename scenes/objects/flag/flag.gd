class_name Flag extends Area3D

var position_tween: Tween
var is_grabbed := false

@onready var grid_position: Vector3i = Vector3i(position)
@onready var anchor: Node3D = $Anchor
@onready var tile_sprite: TileSprite = $Anchor/TileSprite


func grab() -> void:
	monitoring = false
	is_grabbed = true
	animate_raise()


func animate_raise() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(anchor, "position", anchor.position + Vector3.UP, 0.2)
	tile_sprite.animation_player.play("bounce")


func change_flag_pos(new_pos: Vector3i) -> void:
	grid_position = new_pos
	global_position = new_pos
	animate_to_grid_position()


func animate_to_grid_position() -> void:
	if position_tween: position_tween.kill()
	position_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var offset := Vector3.UP if is_grabbed else Vector3.ZERO
	var target_pos := Vector3(grid_position) + offset
	position_tween.tween_property(anchor, "global_position", target_pos, 0.2)
