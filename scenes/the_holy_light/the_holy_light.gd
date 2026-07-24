class_name TheHolyLight extends Area3D

var ufo_anim_radians: float = 0.0
@onready var ufo_origin: Node3D = $UfoOrigin


func _process(delta: float) -> void:
	ufo_anim_radians += delta
	ufo_origin.rotation.x = 0.05 * sin(ufo_anim_radians)
	ufo_origin.rotation.z = 0.05 * cos(ufo_anim_radians)
	
