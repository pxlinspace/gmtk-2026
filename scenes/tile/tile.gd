class_name Tile extends Area3D

signal stepped_on
signal stepped_off

@export var palette: PaletteResource

@onready var anchor: Node3D = $Anchor
@onready var label: Label3D = $Anchor/Label3D
@onready var tile_mesh: MeshInstance3D = $Anchor/MeshInstance
@onready var outline_mesh: MeshInstance3D = $Anchor/MeshInstance/MeshOutline

var countdown: int = 0
var step_tween: Tween
var is_disabled: bool = false
var is_infinity: bool = false


func _ready() -> void:
	stepped_on.connect(_on_stepped_on)
	stepped_off.connect(_on_stepped_off)


func set_countdown(new_value: int) -> void:
	countdown = new_value
	if countdown <= 0:
		is_disabled = true
		hide()
		return

	label.text = str(countdown)
	change_tile_color(palette.get("color_" + str(new_value)))


func set_infinity() -> void:
	countdown = INF
	is_infinity = true
	label.font_size = 96
	label.text = "∞"

	change_tile_color(palette.color_infinity)


func change_tile_color(new_color: Color) -> void:
	var lighter_color := new_color.lightened(0.6)
	label.modulate = new_color
	label.outline_modulate = new_color
	change_mesh_color(outline_mesh, new_color)
	change_mesh_color(tile_mesh, lighter_color)


func change_mesh_color(mesh: MeshInstance3D, new_color: Color) -> void:
	var temp_mat: BaseMaterial3D = mesh.get_active_material(0).duplicate()
	temp_mat.albedo_color = new_color
	mesh.set_surface_override_material(0, temp_mat)


func _on_stepped_on() -> void:
	if step_tween: step_tween.kill()
	step_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	step_tween.tween_property(anchor, "position:y", -0.2, 0.2)


func _on_stepped_off() -> void:
	if not is_infinity: set_countdown(countdown - 1)

	if step_tween: step_tween.kill()
	step_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	step_tween.tween_property(anchor, "position:y", 0.0, 0.2)
