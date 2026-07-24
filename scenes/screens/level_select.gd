extends Node3D

func _on_back_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/screens/main_menu.tscn")
