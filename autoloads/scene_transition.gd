extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mouse_eater: ColorRect = $InvisibleMouseEater

@onready var in_audio: AudioStreamPlayer = $InAudio
@onready var out_audio: AudioStreamPlayer = $OutAudio


func _ready() -> void:
	mouse_eater.hide()


func reload_current_scene() -> void:
	await transition_out()
	get_tree().reload_current_scene()
	transition_in()


func change_scene_to_file(scene_path: String) -> void:
	await transition_out()
	ResourceLoader.load_threaded_request(scene_path)
	while ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_path))
	await RenderingServer.frame_post_draw
	transition_in()


func transition_out() -> void:
	mouse_eater.visible = true
	animation_player.play("transition_out")
	in_audio.play()
	await animation_player.animation_finished


func transition_in() -> void:
	await get_tree().process_frame
	out_audio.play()
	
	mouse_eater.visible = false
	animation_player.play("transition_in")
