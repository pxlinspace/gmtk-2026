extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mouse_eater: ColorRect = $InvisibleMouseEater


func _ready() -> void:
	mouse_eater.hide()


func reload_current_scene() -> void:
	await transition_out()
	get_tree().reload_current_scene()
	transition_in()


func change_scene_to_file(scene_path: String) -> void:
	await transition_out()
	get_tree().change_scene_to_file(scene_path)
	transition_in()


func transition_out() -> void:
	mouse_eater.visible = true
	animation_player.play("transition_out")
	await animation_player.animation_finished


func transition_in() -> void:
	await get_tree().process_frame

	mouse_eater.visible = false
	animation_player.play("transition_in")
