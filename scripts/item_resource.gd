class_name ItemResource extends Resource

@export var item_name: String = "item"
@export_multiline var item_desc: String = "its an item"
@export var sprite_frames: SpriteFrames = SpriteFrames.new()

func use_item(root: Node, pos: Vector3i) -> void:
	print(item_name + " used!")
