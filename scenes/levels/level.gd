class_name Level extends Node3D

const tile_scene = preload("res://scenes/tile/tile.tscn")

@onready var level_map: GridMap = $LevelMap

func _ready() -> void:
	spawn_tiles()

func spawn_tiles() -> void:
	var cells: Array[Vector3i] = level_map.get_used_cells()
	var tile_container := Node.new()
	add_child(tile_container)
	for cell_pos in cells:
		var idx := level_map.get_cell_item(cell_pos)
		var tile := tile_scene.instantiate() as Tile
		tile.set_countdown(int(level_map.mesh_library.get_item_name(idx)))
		tile_container.add_child(tile)
		tile.global_position = level_map.to_global(cell_pos)
	level_map.queue_free()
