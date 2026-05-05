# ItemSlot.gd
extends Panel
signal slot_clicked(fragment_data)
@onready var icon = $TextureRect
@onready var label = $Label
var fragment_data = null
var is_empty: bool = true

func _ready():
	custom_minimum_size = Vector2(80, 80)
	size = Vector2(80, 80)
	clip_contents = true
	icon.visible = false
	
	label.anchor_top = 0.78
	label.anchor_bottom = 1.0
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.offset_left = 2
	label.offset_right = -2
	label.offset_top = 0
	label.offset_bottom = -2
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.add_theme_font_size_override("font_size", 7)
	label.add_theme_color_override("font_color", Color(0.65, 0.72, 0.8))
	
	icon.anchor_left = 0.0
	icon.anchor_right = 1.0
	icon.anchor_top = 0.0
	icon.anchor_bottom = 0.78
	icon.offset_left = 4
	icon.offset_right = -4
	icon.offset_top = 4
	icon.offset_bottom = 0
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.clip_contents = true
	
	_set_selected(false)

func setup(data):
	is_empty = false
	fragment_data = data
	# Truncar nombre si es muy largo
	var nombre = data["nombre"]
	if nombre.length() > 11:
		nombre = nombre.substr(0, 11) + "…"
	label.text = nombre
	icon.visible = true
	if data.get("imagen", "") != "":
		icon.texture = load(data["imagen"])
	_set_selected(false)

func set_empty():
	is_empty = true
	fragment_data = null
	label.text = ""
	icon.texture = null
	icon.visible = false
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.09, 0.12)
	style.border_color = Color(0.0, 0.0, 0.0, 0.0)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.set_border_width_all(0)
	add_theme_stylebox_override("panel", style)

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
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	if value:
		style.border_color = Color(0.78, 0.66, 0.29)
		style.set_border_width_all(2)
	else:
		style.border_color = Color(0.12, 0.18, 0.25)
		style.set_border_width_all(1)
	add_theme_stylebox_override("panel", style)
