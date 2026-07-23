extends Node

var curr_timestep: int = -1

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout

	advance_time()

func advance_time() -> void:
	curr_timestep += 1
	Events.timestep.emit(curr_timestep)
