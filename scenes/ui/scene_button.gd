class_name SceneButton extends Button

@export_file("*.tscn", "*.scn") var scene_path: String

func _on_pressed() -> void:
	SceneTransition.change_scene_to_file(scene_path)
