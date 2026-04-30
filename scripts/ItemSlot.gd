# ItemSlot.gd
extends Button

@onready var texture_rect = $TextureRect
@onready var label = $Label

var item_data: Dictionary = {}
var is_selected: bool = false

func _ready():
	# Tamaño fijo del slot
	custom_minimum_size = Vector2(80, 80)
	size = Vector2(80, 80)
	
	# TextureRect ocupa todo el slot
	texture_rect.anchor_left = 0.0
	texture_rect.anchor_top = 0.0
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	texture_rect.offset_left = 0
	texture_rect.offset_top = 0
	texture_rect.offset_right = 0
	texture_rect.offset_bottom = 0
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Label en la parte inferior
	label.anchor_left = 0.0
	label.anchor_top = 0.75
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 0
	label.offset_top = 0
	label.offset_right = 0
	label.offset_bottom = 0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 10)
	
	# Eventos
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func setup(data: Dictionary):
	item_data = data
	texture_rect.texture = load(data["icon_path"])
	label.text = data["name"]
	modulate = Color(1, 1, 1)

func set_empty():
	item_data = {}
	texture_rect.texture = null
	label.text = ""
	modulate = Color(1, 1, 1)
	is_selected = false

func _on_pressed():
	if item_data.is_empty():
		return
	
	if is_selected:
		# Deseleccionar
		is_selected = false
		modulate = Color(1, 1, 1)
		print("Deseleccionado: ", item_data["name"])
	else:
		# Seleccionar
		is_selected = true
		modulate = Color(1, 0.85, 0, 1)  # dorado al seleccionar
		print("Seleccionaste: ", item_data["name"])

func _on_mouse_entered():
	if item_data.is_empty():
		return
	if not is_selected:
		modulate = Color(1.2, 1.2, 1.2)  # aclarar en hover

func _on_mouse_exited():
	if not is_selected:
		modulate = Color(1, 1, 1)  # volver a normal
	# si está seleccionado mantiene el dorado
