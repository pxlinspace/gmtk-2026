class_name MainMenu extends Node3D

@onready var black_screen: ColorRect = $CanvasLayer/BlackScreen
@onready var the_holy_light: TheHolyLight = $TheHolyLight
@onready var button_container: VBoxContainer = $CanvasLayer/ButtonContainer
@onready var start_label: Label = $CanvasLayer/StartLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_game_audio: AudioStreamPlayer = $StartGameAudio

var ready_to_start: bool = false


func _ready() -> void:
	AudioPlayer.play("Menu")
	
	if Events.game_began:
		the_holy_light.hide()
		start_label.hide()
		button_container.position.x = 70.0
	else:
		black_screen.show()
		await get_tree().create_timer(0.5).timeout
		var tween := create_tween()
		tween.tween_property(black_screen, "color", Color(Color.BLACK, 0), 0.5)
		tween.tween_callback(black_screen.hide)
		await get_tree().create_timer(0.1).timeout
		animation_player.play("show_start_label")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if not Events.game_began and ready_to_start and (event is InputEventKey or event is InputEventMouseButton):
		Events.game_began = true
		animation_player.play("start")
		start_game_audio.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show_start_label":
		ready_to_start = true
