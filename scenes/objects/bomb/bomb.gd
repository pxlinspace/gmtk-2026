class_name Bomb extends Node3D

const EXPLOSION_EFFECT = preload("uid://raq4p4c8uiwg")

const explode_dirs: Array[Vector3i] = [
	Vector3i(1, 0, 0),
	Vector3i(-1, 0, 0),
	Vector3i(0, 0, 1),
	Vector3i(0, 0, -1),

	Vector3i(-1, 0, -1),
	Vector3i(1, 0, -1),
	Vector3i(1, 0, 1),
	Vector3i(-1, 0, 1),
]

var explosion_radius: int = 1
var curr_countdown: int = 0
var explosion_damage: int = 1


@onready var label: Label3D = $Label3D


func _ready() -> void:
	Events.pre_timestep.connect(_on_timestep)


func set_countdown(new_value: int) -> void:
	curr_countdown = new_value
	if curr_countdown <= 0:
		explode()
		return

	label.text = str(curr_countdown)


func explode() -> void:
	print("explode")
	var explosion := EXPLOSION_EFFECT.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.position = global_position
	Events.cam_shake.emit(0.6)

	var affected_tiles: Array[Tile] = []
	for dir in explode_dirs:
		for i in explosion_radius:
			for d in explode_dirs:
				var check_pos := Vector3i(global_position) + dir * i + d
				var areas := Utils.shapecast_at_pos(check_pos)
				for area in areas:
					if area is Tile and not area.is_disabled and area not in affected_tiles:
						affected_tiles.append(area)

	for tile in affected_tiles:
		for x in range(explosion_damage):
			tile.stepped_off.emit()

	queue_free()


func _on_timestep(_curr_timestep: int) -> void:
	set_countdown(curr_countdown - 1)
