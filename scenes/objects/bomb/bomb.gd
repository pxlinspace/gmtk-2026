class_name Bomb extends Node3D

const EXPLOSION_EFFECT = preload("uid://raq4p4c8uiwg")
const BOMB_SQUARE = preload("res://scenes/effects/bomb_square.tscn")

@onready var squares: Node3D = $Squares

var explosion_radius: int = 1
var curr_countdown: int = 0
var explosion_damage: int = 1
var explosion_dirs: Array[Vector3i] = []


@onready var label: Label3D = $Label3D
@onready var charge_audio: AudioStreamPlayer = $ChargeAudio


func _ready() -> void:
	Events.pre_timestep.connect(_on_timestep)

	update_squares()


func set_countdown(new_value: int) -> void:
	charge_audio.play()
	charge_audio.pitch_scale += 1
	curr_countdown = new_value
	if curr_countdown <= 0:
		explode()
		return

	label.text = str(curr_countdown)


func explode() -> void:
	print("explode")
	AudioPlayer.play("Explosion")
	var explosion := EXPLOSION_EFFECT.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.position = global_position
	Events.cam_shake.emit(0.6)

	var tiles := get_affected_tiles()
	for tile in tiles:
		for x in range(explosion_damage):
			tile.stepped_off.emit()

	queue_free()


func get_affected_tiles() -> Array[Tile]:
	var affected_tiles: Array[Tile] = []
	for dir in explosion_dirs:
		for i in range(explosion_radius):
			var check_pos := Vector3i(global_position) + dir * i
			var areas := Utils.shapecast_at_pos(check_pos)
			for area in areas:
				if area is Tile and not area.is_disabled and area not in affected_tiles:
					affected_tiles.append(area)
	return affected_tiles


func update_squares() -> void:
	for child in squares.get_children():
		child.queue_free()

	var tiles := get_affected_tiles()
	for tile in tiles:
		var square := BOMB_SQUARE.instantiate() as Node3D
		squares.add_child(square)
		square.global_position = tile.global_position


func _on_timestep(_curr_timestep: int) -> void:
	set_countdown(curr_countdown - 1)

	update_squares()
