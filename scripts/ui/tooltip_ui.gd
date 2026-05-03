# tooltip_ui.gd
extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/Label

func _ready():
	panel.visible = false
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.12, 0.9)
	style.border_color = Color(0.0, 0.78, 1.0, 0.6)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(4)
	panel.add_theme_stylebox_override("panel", style)
	
	label.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
	label.add_theme_font_size_override("font_size", 12)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF

func show_tooltip(texto: String):
	label.text = texto
	panel.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	label.reset_size()
	panel.size = Vector2.ZERO
	panel.size = label.size + Vector2(16, 10)
	panel.visible = true

func hide_tooltip():
	panel.visible = false

func _process(_delta):
	if panel.visible:
		var mouse = get_viewport().get_mouse_position()
		panel.global_position = mouse + Vector2(-panel.size.x / 2, -50)
