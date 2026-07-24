class_name TheHolyLight extends Area3D

@onready var ufo_origin: Node3D = $UfoOrigin
@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var beam: Node3D = $Beam

var ufo_anim_radians: float = 0.0
var is_active: bool = false


func _ready() -> void:
	Events.all_treasure_gotten.connect(_on_all_treasure_gotten)

	await get_tree().create_timer(1.5).timeout
	set_active(false)


func _process(delta: float) -> void:
	ufo_anim_radians += delta
	ufo_origin.rotation.x = 0.05 * sin(ufo_anim_radians)
	ufo_origin.rotation.z = 0.05 * cos(ufo_anim_radians)


func set_active(new_value: bool) -> void:
	is_active = new_value
	collider.disabled = not new_value
	beam.visible = new_value


func _on_all_treasure_gotten() -> void:
	set_active(true)
	print("all treasure collected, get back to the ship!")
