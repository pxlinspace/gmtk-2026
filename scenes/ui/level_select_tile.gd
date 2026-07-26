extends Control

@export var level_resource: LevelResource

@export var lock_icon: Texture2D
@export var collect_icon: Texture2D
@export var defeat_icon: Texture2D
@export var both_icon: Texture2D

@onready var icon: TextureRect = $LevelPanel/CenterContainer/Icon
@onready var level_label: Label = $Panel/Label

var is_locked: bool = false

func _ready() -> void:
	level_label.text = level_resource.level_name

	if not SaveManager.get_level_completed(level_resource.level_scene):
		icon.texture = lock_icon
		is_locked = true
		return

	if LevelResource.LevelMode.COLLECT in level_resource.level_mode:
		if LevelResource.LevelMode.DEFEAT in level_resource.level_mode:
			icon.texture = both_icon
		else:
			icon.texture = collect_icon
	elif LevelResource.LevelMode.DEFEAT in level_resource.level_mode:
		icon.texture = defeat_icon


func _on_level_panel_pressed() -> void:
	if is_locked:
		return
	SceneTransition.change_scene_to_file(level_resource.level_scene)
