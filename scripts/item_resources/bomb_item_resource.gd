class_name BombItemResource extends ItemResource

const bomb_scene = preload("res://scenes/objects/bomb/bomb.tscn")

@export var explosion_radius: int = 1
@export var explosion_countdown: int = 5
@export var explosion_damage: int = 1


func use_item(root: Node, pos: Vector3i) -> void:
	super.use_item(root, pos)

	var bomb := bomb_scene.instantiate() as Bomb
	bomb.position = pos
	bomb.explosion_radius = explosion_radius
	bomb.explosion_damage = explosion_damage
	root.add_child(bomb)
	bomb.set_countdown(explosion_countdown)
