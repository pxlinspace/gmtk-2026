class_name Level extends Node3D

const RESTART_TIME: float = 0.35
const GOAL_COMPLETED_COLOR := Color("80ff8a")

const tile_scene = preload("res://scenes/tile/tile.tscn")

@export var level_resource: LevelResource

@onready var level_map: GridMap = $LevelMap
@onready var level_timer: Timer = $LevelTimer
@onready var timer_bar: TimerBar = $HudLayer/TimerBar
@onready var flashbang: ColorRect = $HudLayer/Flashbang
@onready var restart_progress: TextureProgressBar = $HudLayer/RestartProgressBar

@onready var treasure_display: HBoxContainer = $HudLayer/MissionPanel/MissionMargin/MissionContainer/TreasureDisplay
@onready var enemies_display: HBoxContainer = $HudLayer/MissionPanel/MissionMargin/MissionContainer/EnemiesDisplay

@onready var treasure_label: Label = $HudLayer/MissionPanel/MissionMargin/MissionContainer/TreasureDisplay/TreasureLabel
@onready var enemies_label: Label = $HudLayer/MissionPanel/MissionMargin/MissionContainer/EnemiesDisplay/EnemiesLabel

@onready var treasure_count: Label = $HudLayer/MissionPanel/MissionMargin/MissionContainer/TreasureDisplay/TreasureCount
@onready var enemies_count: Label = $HudLayer/MissionPanel/MissionMargin/MissionContainer/EnemiesDisplay/EnemiesCount

@onready var crackle: TextureRect = $HudLayer/Crackle
@onready var friend_container: VBoxContainer = $HudLayer/FriendContainer
@onready var level_name_label: Label = $HudLayer/LevelContainer/LevelLabel
@onready var level_instructions_label: Label = $HudLayer/FriendContainer/PanelContainer/MarginContainer/DescriptionLabel

var collectable_treasure: Array[TreasureItem] = []
var killable_enemies: Array[BaseEnemy] = []

var treasure_collected: int = 0
var enemies_killed: int = 0
var restart_value: float = 0.0
var is_restarting: bool = false


func _ready() -> void:
	Events.timestep.connect(_on_timestep)
	Events.treasure_received.connect(_on_treasure_received)
	Events.toggle_pause.connect(_on_paused)
	Events.enemy_died.connect(_on_enemy_died)
	Events.all_treasure_gotten.connect(_on_all_treasure_gotten)
	Events.all_enemies_killed.connect(_on_all_enemies_killed)

	timer_bar.set_speed_up(false)
	restart_progress.hide()

	spawn_tiles()
	level_timer.wait_time = level_resource.level_countdown
	Events.player_beamed_down.connect(level_timer.start)

	for node in get_tree().get_nodes_in_group("treasure"):
		if node is TreasureItem:
			collectable_treasure.append(node)

	for node in get_tree().get_nodes_in_group("enemies"):
		if node is BaseEnemy:
			killable_enemies.append(node)

	if LevelResource.LevelMode.COLLECT in level_resource.level_mode:
		treasure_display.show()
		update_treasure_count()
	if LevelResource.LevelMode.DEFEAT in level_resource.level_mode:
		enemies_display.show()
		update_enemies_count()

	level_name_label.text = level_resource.level_name

	if not level_resource.has_instructions:
		friend_container.hide()
		crackle.hide()
	else:
		level_instructions_label.text = level_resource.level_instructions
		level_instructions_label.visible_ratio = 0.0
		var instructions_tween := create_tween()
		instructions_tween.tween_property(level_instructions_label, "visible_ratio", 1.0, 1.5)

func _process(dt: float) -> void:
	if not level_timer.is_stopped():
		timer_bar.set_progress(1.0 - level_timer.time_left / level_timer.wait_time)
	if is_restarting:
		restart_value += dt
		restart_progress.value = restart_value / RESTART_TIME
		if restart_value >= RESTART_TIME:
			restart_level()
	else:
		restart_value = 0.0


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
	Events.pre_move_missed.emit()
	Clock.advance_time()
	Events.move_missed.emit()

	var flashbang_tween := create_tween()
	flashbang.color.a = 0.6
	flashbang_tween.tween_property(flashbang, "color:a", 0.0, 0.75)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("speed_up"):
		Engine.time_scale = 3.0
		timer_bar.set_speed_up(true)
		Events.pre_move_missed.emit()
		Clock.advance_time()

	if event.is_action_released("speed_up"):
		Engine.time_scale = 1.0
		timer_bar.set_speed_up(false)

	if event.is_action_pressed("restart"):
		restart_progress.show()
		is_restarting = true
	if event.is_action_released("restart"):
		restart_progress.hide()
		is_restarting = false


func restart_level() -> void:
	is_restarting = false
	Events.toggle_pause.emit(true)
	Events.restart_level.emit()
	SceneTransition.reload_current_scene()


func update_treasure_count() -> void:
	treasure_count.text = str(treasure_collected) + "/" + str(collectable_treasure.size())


func update_enemies_count() -> void:
	enemies_count.text = str(enemies_killed) + "/" + str(killable_enemies.size())


func check_mission_complete() -> bool:
	for mode in level_resource.level_mode:
		if mode == LevelResource.LevelMode.COLLECT and treasure_collected < collectable_treasure.size():
			return false
		if mode == LevelResource.LevelMode.DEFEAT and enemies_killed < killable_enemies.size():
			return false
	return true


func _on_treasure_received() -> void:
	print("found a treasure!")
	treasure_collected += 1
	update_treasure_count()
	if treasure_collected >= collectable_treasure.size():
		Events.all_treasure_gotten.emit()


func _on_enemy_died(_enemy: BaseEnemy) -> void:
	print("enemy died!")
	enemies_killed += 1
	update_enemies_count()
	if enemies_killed >= killable_enemies.size():
		Events.all_enemies_killed.emit()


func _on_all_treasure_gotten() -> void:
	treasure_display.modulate = GOAL_COMPLETED_COLOR
	if check_mission_complete():
		Events.mission_complete.emit()

func _on_all_enemies_killed() -> void:
	enemies_display.modulate = GOAL_COMPLETED_COLOR
	if check_mission_complete():
		Events.mission_complete.emit()
