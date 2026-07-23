extends Node

var curr_timestep: int = -1

func _ready() -> void:
	advance_time()

func advance_time() -> void:
	curr_timestep += 1
	Events.timestep.emit(curr_timestep)
