class_name TileItem extends Area3D

signal collect


func _ready() -> void:
	collect.connect(_on_collect)


func _on_collect() -> void:
	queue_free()
