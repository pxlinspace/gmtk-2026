extends Node3D

@export var animation_speed_scale: float = 1.0
@onready var clouds: MeshInstance3D = $Clouds
@onready var clouds_2: MeshInstance3D = $Clouds2


func _process(delta: float) -> void:
	clouds.rotation.y += delta * 0.015 * animation_speed_scale
	clouds_2.rotation.y += delta * 0.04 * animation_speed_scale
