extends CanvasLayer

signal on_inspect(fragment_data)
signal on_scan(fragment_data)

@onready var titulo = $Panel/VBoxContainer/Label
@onready var btn_inspect = $Panel/VBoxContainer/BtnInspect
@onready var btn_scan = $Panel/VBoxContainer/BtnScan
@onready var btn_close = $Panel/VBoxContainer/BtnClose

var current_fragment = null

func _ready():
	print("ContextMenu ready, layer: ", layer)
	visible = false
	btn_inspect.text = "Inspeccionar"
	btn_scan.text = "Escanear"
	btn_close.text = "✕"
	btn_inspect.pressed.connect(_on_inspect)
	btn_scan.pressed.connect(_on_scan)
	btn_close.pressed.connect(hide_menu)
	print("Botones conectados")
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.07, 0.12, 0.95)
	style.border_color = Color(0.0, 0.78, 1.0, 0.8)
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(6)
	$Panel.add_theme_stylebox_override("panel", style)
	
	titulo.add_theme_color_override("font_color", Color(0.0, 0.78, 1.0))
	titulo.add_theme_font_size_override("font_size", 10)
	
	for btn in [btn_inspect, btn_scan, btn_close]:
		btn.custom_minimum_size = Vector2(120, 24)
		btn.add_theme_font_size_override("font_size", 11)

func show_menu(fragment_data, position: Vector2):
	current_fragment = fragment_data
	visible = true
	await get_tree().process_frame
	$Panel.size = Vector2(0, 0)
	await get_tree().process_frame
	var pos = Vector2(position.x - $Panel.size.x / 2, position.y - $Panel.size.y - 8)
	pos.x = clamp(pos.x, 0, 1920 - $Panel.size.x)
	pos.y = clamp(pos.y, 0, 1080 - $Panel.size.y)
	$Panel.position = pos

func hide_menu():
	visible = false
	current_fragment = null

func _on_inspect():
	print("INSPECT clickeado")
	if current_fragment:
		emit_signal("on_inspect", current_fragment)
	hide_menu()

func _on_scan():
	print("SCAN clickeado")
	if current_fragment:
		emit_signal("on_scan", current_fragment)
	hide_menu()
