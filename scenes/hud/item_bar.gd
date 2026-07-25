class_name ItemBar extends Node2D

const ITEM_SEPARATION = 120.0
const item_scene = preload("res://scenes/hud/item_bar_item.tscn")


func _ready() -> void:
	Events.item_received.connect(_on_item_received)


func set_item_positions() -> void:
	if get_child_count() > 2:
		for i in range(get_child_count() - 2):
			get_child(get_child_count() - 1).queue_free()

	for i in range(get_child_count()):
		var item := get_child(i) as ItemBarItem
		item.set_button("e" if i == 0 else "q")
		item.position.x = i * -ITEM_SEPARATION


func _on_item_received(item_resource: ItemResource) -> void:
	var item_bar_item := item_scene.instantiate() as ItemBarItem
	item_bar_item.item_used.connect(_on_item_used)
	add_child(item_bar_item)
	move_child(item_bar_item, 0)
	item_bar_item.set_item(item_resource)

	set_item_positions()

func _on_item_used(_item: ItemBarItem) -> void:
	set_item_positions()
