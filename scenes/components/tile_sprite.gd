class_name TileSprite extends AnimatedSprite3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func center() -> void:
	position.y += 0.5
	offset.y = 0.0
