extends CanvasLayer

@onready var slots_container = $Panel/VBoxContainer/HBoxContainer
@onready var panel = $Panel

var item_slot_scene = preload("res://scenes/ui_elements/inventory/ItemSlot.tscn")
const MAX_SLOTS = 5

func _ready():
	_setup_panel()
	FragmentManager.fragmento_agregado.connect(_on_fragmento_agregado)
	_build_slots()

func _setup_panel():
	panel.size = Vector2(560, 140)
	panel.position = Vector2((1920 - 560) / 2, 16)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.07, 0.10, 0.85)
	style.border_color = Color(0.0, 0.78, 1.0, 0.6)
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	panel.add_theme_stylebox_override("panel", style)

func _build_slots():
	for child in slots_container.get_children():
		child.queue_free()

	for i in MAX_SLOTS:
		var slot = item_slot_scene.instantiate()
		slots_container.add_child(slot)

		if i < FragmentManager.inventario.size():
			slot.setup(FragmentManager.inventario[i])
		else:
			slot.set_empty()

func _on_fragmento_agregado(_fragmento):
	_build_slots()
	await get_tree().process_frame
	for slot in slots_container.get_children():
		if not slot.is_empty:
			if not slot.slot_clicked.is_connected(_on_slot_clicked):
				slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(fragment_data):
	print("Slot clickeado: ", fragment_data["nombre"])
