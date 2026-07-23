class_name Tile extends Area3D

var countdown: int = 0

func set_countdown(new_value: int):
	countdown = new_value
	$Label3D.text = str(countdown)
