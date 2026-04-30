# InventoryUI.gd
extends CanvasLayer

@onready var slots_container = $Panel/ScrollContainer/HBoxContainer
var item_slot_scene = preload("res://scenes/ui_elements/inventory/ItemSlot.tscn")

func _ready():
	InventoryManager.inventory_changed.connect(_refresh)
	
	# --- ITEMS DE PRUEBA (borra este bloque cuando el juego esté listo) ---
	var items_prueba = [
		{"name": "Hacha",    "icon_path": "res://icon.svg"},
		{"name": "Cuchillo", "icon_path": "res://icon.svg"},
		{"name": "Llave",    "icon_path": "res://icon.svg"},
	]
	for item in items_prueba:
		var slot = item_slot_scene.instantiate()
		slots_container.add_child(slot)
		slot.setup(item)
	# --- FIN ITEMS DE PRUEBA ---

func _refresh():
	for child in slots_container.get_children():
		child.queue_free()
	for item in InventoryManager.items:
		var slot = item_slot_scene.instantiate()
		slots_container.add_child(slot)
		slot.setup(item)
