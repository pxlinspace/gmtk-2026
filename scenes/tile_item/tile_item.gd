@tool
class_name TileItem extends Area3D

signal collect

@export var item_resource: ItemResource:
	set(value):
		item_resource = value
		var sprite := $Anchor/TileSprite
		if not value:
			sprite.sprite_frames = null
		else:
			sprite.sprite_frames = item_resource.sprite_frames


func _ready() -> void:
	collect.connect(_on_collect)


func _on_collect() -> void:
	if not self is TreasureItem:
		AudioPlayer.play("ItemCollect")
	Events.item_gotten.emit(self)
	queue_free()
