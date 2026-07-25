extends Node

var time: float = 0.0
var curr_timestep: int = -1


func _ready() -> void:
	Events.restart_level.connect(_on_reset_timestep)
	Events.next_level.connect(_on_reset_timestep)

	# await get_tree().create_timer(1.0).timeout

	# advance_time()


func _process(dt: float) -> void:
	time += dt


func advance_time() -> void:
	curr_timestep += 1
	Events.pre_timestep.emit(curr_timestep)
	await get_tree().process_frame
	Events.timestep.emit(curr_timestep)


func _on_reset_timestep() -> void:
	curr_timestep = -1
	# advance_time()
