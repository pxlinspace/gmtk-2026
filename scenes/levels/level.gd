class_name Level extends Node3D

const tile_scene = preload("res://scenes/tile/tile.tscn")

## how long before the time automatically steps
@export var level_countdown_time: float = 2.0

@onready var level_map: GridMap = $LevelMap
@onready var level_timer: Timer = $LevelTimer
@onready var timer_bar: TimerBar = $HudLayer/TimerBar
@onready var flashbang: ColorRect = $HudLayer/Flashbang

func _ready() -> void:
	Events.timestep.connect(_on_timestep)

	spawn_tiles()
	level_timer.wait_time = level_countdown_time
	level_timer.start()

func _process(dt: float) -> void:
	timer_bar.set_progress(1.0 - level_timer.time_left / level_timer.wait_time)

func spawn_tiles() -> void:
	var cells: Array[Vector3i] = level_map.get_used_cells()
	var tile_container := Node.new()
	add_child(tile_container)
	for cell_pos in cells:
		var idx := level_map.get_cell_item(cell_pos)
		var tile := tile_scene.instantiate() as Tile
		tile_container.add_child(tile)
		tile.global_position = level_map.to_global(cell_pos)
		tile.set_countdown(int(level_map.mesh_library.get_item_name(idx)))
	level_map.queue_free()

func _on_timestep(_curr_timestep: int) -> void:
	level_timer.start()

func _on_level_timer_timeout() -> void:
	Events.move_missed.emit()

	var flashbang_tween := create_tween()
	flashbang.color.a = 0.6
	flashbang_tween.tween_property(flashbang, "color:a", 0.0, 0.75)
