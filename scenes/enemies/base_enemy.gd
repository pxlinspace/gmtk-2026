class_name BaseEnemy extends Area3D

@onready var grid_position: Vector3i = Vector3i(position)
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor
@onready var collider: CollisionShape3D = $CollisionShape3D

var is_dead: bool = false


func _ready() -> void:
	Events.timestep.connect(_on_timestep)

func move(_curr_timestep: int) -> void:
	pass

func die() -> void:
	Events.enemy_died.emit(self)

func check_curr_tile() -> void:
	var areas := Utils.shapecast_at_pos(grid_position)
	var is_on_tile := areas.any(func(a: Area3D) -> bool: return a is Tile and not a.is_disabled)
	if not is_on_tile:
		die()

func _on_timestep(curr_timestep: int) -> void:
	check_curr_tile()
	move(curr_timestep)
