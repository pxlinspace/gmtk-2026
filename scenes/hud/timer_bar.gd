class_name TimerBar extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hand_sprite: Sprite2D = $WatchSprites/HandSprite
@onready var speed_up_sprite: Sprite2D = $WatchSprites/SpeedUpSprite
@onready var speed_up_label: Label = $SpeedUpLabel


func _ready() -> void:
	Events.timestep.connect(_on_timestep)


func set_progress(value: float) -> void:
	hand_sprite.frame = floor(value * hand_sprite.hframes)


func set_speed_up(value: bool) -> void:
	speed_up_sprite.visible = value
	speed_up_label.visible = value


func _on_timestep(_curr_timestep: int) -> void:
	animation_player.stop()
	animation_player.play("bounce")
