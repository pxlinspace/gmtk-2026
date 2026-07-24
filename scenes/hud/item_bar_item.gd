class_name ItemBarItem extends Node2D

@export var button_e: Texture2D
@export var button_q: Texture2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var button_sprite: Sprite2D = $Button

var item: ItemResource
var button: String


func set_item(item_resource: ItemResource) -> void:
	item = item_resource
	sprite.sprite_frames = item_resource.sprite_frames


func set_button(button_name: String) -> void:
	button = button_name
	button_sprite.texture = button_e if button_name == "e" else button_q


func _unhandled_input(event: InputEvent) -> void:
	if InputMap.has_action(button) and event.is_action_pressed(button):
		item.use_item(get_tree().current_scene, get_tree().get_nodes_in_group("player")[0].grid_pos)
