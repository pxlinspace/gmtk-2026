class_name LevelResource extends Resource

enum LevelMode {
	COLLECT,
	DEFEAT
}

@export var level_name: String = "the cool level"
@export var level_mode: LevelMode = LevelMode.COLLECT

## how long before the time automatically steps
@export var level_countdown: float = 1.0

@export var has_instructions: bool = false
@export_multiline() var level_instructions: String = ""
