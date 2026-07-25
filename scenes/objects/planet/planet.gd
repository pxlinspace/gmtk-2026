extends Node3D

@onready var clouds: MeshInstance3D = $Clouds
@onready var clouds_2: MeshInstance3D = $Clouds2


func _process(delta: float) -> void:
	clouds.rotation.y += delta * 0.015
	clouds_2.rotation.y += delta * 0.04
	
	
