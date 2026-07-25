extends Node3D

var is_near_ship := false


func _ready() -> void:
	Events.mission_complete.connect(show_arrow)


func show_arrow() -> void:
	tween_scale(1.0)
	show()


func _process(_delta: float) -> void:
	if not visible:
		return
	var ship_pos := Events.ship_position + Vector3(0.5, 0, 0.5)
	var pos := global_position
	rotation.y = atan2(pos.z - ship_pos.z, ship_pos.x - pos.x)
	
	if pos.distance_to(ship_pos) < 3.5 and not is_near_ship:
		is_near_ship = true
		tween_scale(0, Tween.EASE_IN)
	elif pos.distance_to(ship_pos) > 3.5 and is_near_ship:
		is_near_ship = false
		tween_scale(1)


func tween_scale(new_scale: float, ease_type: Tween.EaseType = Tween.EASE_OUT) -> void:
	var tween := create_tween().set_ease(ease_type).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector3.ONE * new_scale, 0.5)
