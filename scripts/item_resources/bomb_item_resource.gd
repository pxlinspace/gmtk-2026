class_name BombItemResource extends ItemResource

const bomb_scene = preload("res://scenes/objects/bomb/bomb.tscn")

@export var explosion_radius: int = 1
@export var explosion_countdown: int = 5
@export var explosion_damage: int = 1
@export var explosion_dirs: Array[Vector3i] = [
	Vector3i(1, 0, 0),
	Vector3i(-1, 0, 0),
	Vector3i(0, 0, 1),
	Vector3i(0, 0, -1),

	# Vector3i(-1, 0, -1),
	# Vector3i(1, 0, -1),
	# Vector3i(1, 0, 1),
	# Vector3i(-1, 0, 1),
]


func use_item(root: Node, pos: Vector3i) -> void:
	super.use_item(root, pos)

	var bomb := bomb_scene.instantiate() as Bomb
	bomb.position = pos
	bomb.explosion_radius = explosion_radius
	bomb.explosion_damage = explosion_damage
	bomb.explosion_dirs = explosion_dirs
	root.add_child(bomb)
	bomb.set_countdown(explosion_countdown)
