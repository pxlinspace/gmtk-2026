class_name TileItem extends Area3D

signal collect

@export var item_resource: ItemResource


func _ready() -> void:
	collect.connect(_on_collect)


func _on_collect() -> void:
	Events.item_gotten.emit(self, item_resource)
	queue_free()
