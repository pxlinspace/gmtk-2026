@tool
extends Node

@export_tool_button("Delete user data", "Remove") var delete_user_data_button := self.delete_data

const SAVE_FILE_PATH: String = "user://save.json"

var data: Dictionary = {}


func _ready() -> void:
	load_data()


func load_data() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		var json_string: String = file.get_as_text()
		data = JSON.parse_string(json_string)
		file.close()
	else:
		data = {}


func save_data() -> void:
	var file: FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var json_string: String = JSON.stringify(data)
	file.store_string(json_string)
	file.close()


func get_level_completed(level_path: String) -> bool:
	return data.get(level_path, false)


func set_level_completed(level_path: String, completed: bool = true) -> void:
	data[level_path] = completed
	save_data()


func delete_data() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		DirAccess.remove_absolute(SAVE_FILE_PATH)
		print("save deleted")
	else:
		print("no save file to delete")
