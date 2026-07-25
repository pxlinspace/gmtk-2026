class_name BaseEnemy extends Area3D

@onready var grid_position: Vector3i = Vector3i(position)
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor
@onready var collider: CollisionShape3D = $CollisionShape3D

var is_dead: bool = false


func _ready() -> void:
	Events.pre_timestep.connect(_on_pre_timestep)
	Events.timestep.connect(_on_timestep)


func move(_curr_timestep: int) -> void:
	pass


func die() -> void:
	if is_dead: return
	is_dead = true
	collider.disabled = true
	Events.enemy_died.emit(self)


func check_curr_tile() -> void:
	var areas := Utils.shapecast_at_pos(grid_position)
	var is_on_tile := areas.any(func(a: Area3D) -> bool: return a is Tile and not a.is_disabled)
	if not is_on_tile:
		die()

func _on_pre_timestep(curr_timestep: int) -> void:
	move(curr_timestep)

func _on_timestep(_curr_timestep: int) -> void:
	check_curr_tile()
