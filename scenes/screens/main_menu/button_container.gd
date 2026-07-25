extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_child_count():
		var button: Button = get_child(i)
		button.mouse_entered.connect(scale_button_up.bind(i))
		button.mouse_exited.connect(scale_button_down.bind(i))


func scale_button_up(button_index: int) -> void:
	var tween := create_tween()
	tween.tween_property(get_child(button_index), "scale", Vector2(1.1, 1.1), 0.2)

func scale_button_down(button_index: int) -> void:
	var tween := create_tween()
	tween.tween_property(get_child(button_index), "scale", Vector2(1, 1), 0.2)
