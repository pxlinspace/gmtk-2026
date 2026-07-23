class_name TimerBar extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand_sprite: Sprite2D = $HandSprite


func _ready() -> void:
	Events.timestep.connect(_on_timestep)


func set_progress(value: float) -> void:
	hand_sprite.frame = floor(value * hand_sprite.hframes)


func _on_timestep(_curr_timestep: int) -> void:
	animation_player.stop()
	animation_player.play("bounce")
