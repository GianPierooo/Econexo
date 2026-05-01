# InventoryUI.gd
extends CanvasLayer

@onready var slots_container = $Panel/HBoxContainer
@onready var panel = $Panel

var item_slot_scene = preload("res://scenes/ui_elements/inventory/ItemSlot.tscn")
const MAX_SLOTS = 6

func _ready():
	_setup_panel()
	FragmentManager.fragmento_agregado.connect(_on_fragmento_agregado)
	_build_slots()

func _setup_panel():
	panel.size = Vector2(1920, 110)
	panel.position = Vector2(0, 970)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.07, 0.10, 0.92)
	style.border_color = Color(0.0, 0.78, 1.0, 0.6)
	style.border_width_top = 2
	panel.add_theme_stylebox_override("panel", style)
	
	slots_container.anchor_left = 0.0
	slots_container.anchor_right = 1.0
	slots_container.anchor_top = 0.0
	slots_container.anchor_bottom = 1.0
	slots_container.offset_left = 20
	slots_container.offset_right = -20
	slots_container.alignment = BoxContainer.ALIGNMENT_CENTER
	slots_container.add_theme_constant_override("separation", 12)

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
	await get_tree().process_frame  # esperar un frame para que los slots se instancien
	for slot in slots_container.get_children():
		if not slot.is_empty:
			if not slot.slot_clicked.is_connected(_on_slot_clicked):
				slot.slot_clicked.connect(_on_slot_clicked)

func _on_slot_clicked(fragment_data):
	var mouse_pos = get_viewport().get_mouse_position()
	# get_parent().get_node("ContextMenu").show_menu(fragment_data, mouse_pos)
	print("Slot clickeado: ", fragment_data["nombre"])
