# ContextMenu.gd
extends Panel

signal on_inspect(fragment_data)
signal on_scan(fragment_data)

@onready var titulo = $VBoxContainer/Label
@onready var btn_inspect = $VBoxContainer/BtnInspect
@onready var btn_scan = $VBoxContainer/BtnScan
@onready var btn_close = $VBoxContainer/BtnClose

var current_fragment = null

func _ready():
	visible = false
	btn_inspect.pressed.connect(_on_inspect)
	btn_scan.pressed.connect(_on_scan)
	btn_close.pressed.connect(hide_menu)

func show_menu(fragment_data, position: Vector2):
	current_fragment = fragment_data
	titulo.text = fragment_data.id + " — " + fragment_data.nombre
	global_position = position - Vector2(0, size.y + 8)
	visible = true

func hide_menu():
	visible = false
	current_fragment = null

func _on_inspect():
	if current_fragment:
		emit_signal("on_inspect", current_fragment)
	hide_menu()

func _on_scan():
	if current_fragment:
		emit_signal("on_scan", current_fragment)
	hide_menu()
