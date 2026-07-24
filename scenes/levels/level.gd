class_name Level extends Node3D

const tile_scene = preload("res://scenes/tile/tile.tscn")

## how long before the time automatically steps
@export var level_countdown_time: float = 2.0

@onready var level_map: GridMap = $LevelMap
@onready var level_timer: Timer = $LevelTimer
@onready var timer_bar: TimerBar = $HudLayer/TimerBar
@onready var flashbang: ColorRect = $HudLayer/Flashbang

var collectable_treasure: Array[TreasureItem] = []
var treasure_collected: int = 0


func _ready() -> void:
	Events.timestep.connect(_on_timestep)
	Events.treasure_received.connect(_on_treasure_received)
	Events.toggle_pause.connect(_on_paused)

	timer_bar.set_speed_up(false)

	spawn_tiles()
	level_timer.wait_time = level_countdown_time
	level_timer.start()

	for node in get_tree().get_nodes_in_group("treasure"):
		if node is TreasureItem:
			collectable_treasure.append(node)


func _process(dt: float) -> void:
	timer_bar.set_progress(1.0 - level_timer.time_left / level_timer.wait_time)


func spawn_tiles() -> void:
	var cells: Array[Vector3i] = level_map.get_used_cells()
	var tile_container := Node.new()
	add_child(tile_container)
	for cell_pos in cells:
		var idx := level_map.get_cell_item(cell_pos)
		var tile := tile_scene.instantiate() as Tile
		var tile_name := level_map.mesh_library.get_item_name(idx)
		tile_container.add_child(tile)
		tile.global_position = level_map.to_global(cell_pos)
		if tile_name == "infinity":
			tile.set_infinity()
		else:
			tile.set_countdown(int(tile_name))
	level_map.queue_free()


func _on_paused(paused: bool) -> void:
	level_timer.paused = paused


func _on_timestep(_curr_timestep: int) -> void:
	level_timer.start()


func _on_level_timer_timeout() -> void:
	Events.move_missed.emit()

	var flashbang_tween := create_tween()
	flashbang.color.a = 0.6
	flashbang_tween.tween_property(flashbang, "color:a", 0.0, 0.75)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		Engine.time_scale = 3.0
		timer_bar.set_speed_up(true)
	if event.is_action_released("shift"):
		Engine.time_scale = 1.0
		timer_bar.set_speed_up(false)
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		Events.restart_level.emit()


func _on_treasure_received() -> void:
	print("found a treasure!")
	treasure_collected += 1
	if treasure_collected >= collectable_treasure.size():
		Events.all_treasure_gotten.emit()
