extends Node3D

@export var max_page: int = 1
@onready var page_left_button: Button = $CanvasLayer/PageLeftButton
@onready var page_right_button: Button = $CanvasLayer/PageRightButton
@onready var container: Control = $CanvasLayer/Container

var curr_page: int = 0
var page_tween: Tween

func _ready() -> void:
	set_page(0)


func set_page(new_page: int) -> void:
	curr_page = clampi(new_page, 0, max_page)
	page_left_button.show()
	page_right_button.show()
	if curr_page == 0:
		page_left_button.hide()
	elif curr_page == max_page:
		page_right_button.hide()

	if page_tween: page_tween.kill()
	page_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	page_tween.tween_property(container, "position:x", -curr_page * 1024, 0.4)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		set_page(curr_page - 1)
	if event.is_action_pressed("right"):
		set_page(curr_page + 1)


func _on_back_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/screens/main_menu.tscn")


func _on_page_left_button_pressed() -> void:
	set_page(curr_page - 1)


func _on_page_right_button_pressed() -> void:
	set_page(curr_page + 1)
