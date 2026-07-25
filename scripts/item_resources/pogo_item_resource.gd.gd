class_name PogoItemResource extends ItemResource

@export var jump_distance: int = 2


func use_item(root: Node, pos: Vector3i) -> void:
	super.use_item(root, pos)

	Events.player_pogo.emit(jump_distance)
