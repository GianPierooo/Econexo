# ItemSlot.gd
extends Panel

signal slot_clicked(fragment_data)

@onready var icon = $TextureRect
@onready var label = $Label

var fragment_data = null
var is_empty: bool = true

func _ready():
	custom_minimum_size = Vector2(72, 72)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.09, 0.12)
	style.border_color = Color(0.12, 0.18, 0.25)
	style.set_border_width_all(1)
	add_theme_stylebox_override("panel", style)
	
	label.anchor_top = 0.75
	label.anchor_bottom = 1.0
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(0.65, 0.72, 0.8))
	
	icon.anchor_right = 1.0
	icon.anchor_bottom = 1.0
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func setup(data):
	is_empty = false
	fragment_data = data
	label.text = data["nombre"]
	if data.get("imagen", "") != "":
		icon.texture = load(data["imagen"])
	_set_selected(false)

func set_empty():
	is_empty = true
	fragment_data = null
	label.text = ""
	icon.texture = null
	_set_selected(false)

func _gui_input(event):
	if is_empty:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("slot_clicked", fragment_data)
			_set_selected(true)

func _set_selected(value: bool):
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.09, 0.12)
	if value:
		style.border_color = Color(0.78, 0.66, 0.29)
		style.set_border_width_all(2)
	else:
		style.border_color = Color(0.12, 0.18, 0.25)
		style.set_border_width_all(1)
	add_theme_stylebox_override("panel", style)
