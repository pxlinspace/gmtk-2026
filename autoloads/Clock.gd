extends Node

var curr_timestep: int = 0

func advance_time() -> void:
	curr_timestep += 1
	Events.timestep.emit(curr_timestep)

