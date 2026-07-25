extends Node2D

const RADIAN_OFFSET: float = 0.75

@export var radians: float = 0.0


func _process(delta: float) -> void:
	radians += delta * 2.0
	if radians > TAU:
		radians = radians - TAU
	
	for i in get_children().size():
		var sprite: Sprite2D = get_child(i)
		sprite.position.y = sin(radians + i * RADIAN_OFFSET) * 7.0
