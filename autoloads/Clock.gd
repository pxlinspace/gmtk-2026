extends Node

var curr_timestep: int = -1


func _ready() -> void:
	Events.restart_level.connect(_on_restart_level)

	# await get_tree().create_timer(1.0).timeout

	# advance_time()


func advance_time() -> void:
	curr_timestep += 1
	Events.timestep.emit(curr_timestep)


func _on_restart_level() -> void:
	curr_timestep = -1
	# advance_time()
