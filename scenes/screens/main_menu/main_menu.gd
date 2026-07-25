class_name MainMenu extends Node3D

@onready var black_screen: ColorRect = $CanvasLayer/BlackScreen


func _ready() -> void:
	if not Events.game_began:
		Events.game_began = true
		black_screen.show()
		await get_tree().create_timer(0.5).timeout
		var tween := create_tween()
		tween.tween_property(black_screen, "color", Color(Color.BLACK, 0), 0.5)
		tween.tween_callback(black_screen.hide)
		AudioPlayer.play("Menu")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
