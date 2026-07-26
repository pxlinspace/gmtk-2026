class_name TheHolyLight extends Area3D

@onready var ufo_origin: Node3D = $UfoOrigin
@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var beam: Node3D = $Beam

var ufo_anim_radians: float = 0.0
var is_active: bool = false


func _ready() -> void:
	Events.ship_position = global_position
	Events.mission_complete.connect(_on_mission_complete)

	await get_tree().create_timer(1.0).timeout
	set_active(false)


func _process(delta: float) -> void:
	ufo_anim_radians += delta
	ufo_origin.rotation.x = 0.05 * sin(ufo_anim_radians)
	ufo_origin.rotation.z = 0.05 * cos(ufo_anim_radians)


func set_active(new_value: bool) -> void:
	is_active = new_value
	collider.disabled = not new_value
	var beam_tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel()
	var target_scale := 1.0 if new_value else 0.0
	beam_tween.tween_property(beam, "scale:x", target_scale, 1.0)
	beam_tween.tween_property(beam, "scale:z", target_scale, 1.0)

func _on_mission_complete() -> void:
	set_active(true)
	print("mission complete, get back to the ship!")
