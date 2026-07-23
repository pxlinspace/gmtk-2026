class_name BaseEnemy extends Area3D

@onready var grid_position: Vector3i = Vector3i(position)
@onready var tile_sprite: TileSprite = $Anchor/TileSprite
@onready var anchor: Node3D = $Anchor

func _ready() -> void:
	Events.timestep.connect(_on_timestep)

func move(_curr_timestep: int) -> void:
	pass

func _on_timestep(curr_timestep: int) -> void:
	move(curr_timestep)
