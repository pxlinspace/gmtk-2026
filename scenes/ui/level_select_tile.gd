extends Control

@export var level_resource: LevelResource

@export var collect_icon: Texture2D
@export var defeat_icon: Texture2D
@export var both_icon: Texture2D

@onready var icon: TextureRect = $LevelPanel/CenterContainer/Icon
@onready var level_label: Label = $Panel/Label

func _ready() -> void:
	if LevelResource.LevelMode.COLLECT in level_resource.level_mode:
		if LevelResource.LevelMode.DEFEAT in level_resource.level_mode:
			icon.texture = both_icon
		else:
			icon.texture = collect_icon
	elif LevelResource.LevelMode.DEFEAT in level_resource.level_mode:
		icon.texture = defeat_icon

	level_label.text = level_resource.level_name


func _on_level_panel_pressed() -> void:
	SceneTransition.change_scene_to_file(level_resource.level_scene)
