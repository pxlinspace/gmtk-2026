extends Node


func play(child_name: String) -> void:
	var player: AudioStreamPlayer = get_node(child_name)
	if not player.playing:
		get_node(child_name).play()


func stop(child_name: String) -> void:
	get_node(child_name).stop()


func stop_all() -> void:
	for player: AudioStreamPlayer in get_children():
		player.stop()
