# InventoryUI.gd
extends CanvasLayer

@onready var hbox = $Panel/ScrollContainer/HBoxContainer
var item_slot_scene = preload("res://scenes/ui_elements/inventory/ItemSlot.tscn")

func _ready():
	InventoryManager.inventory_changed.connect(_refresh)

func _refresh():
	# Limpiar slots anteriores
	for child in hbox.get_children():
		child.queue_free()
	
	# Crear un slot por cada ítem
	for item in InventoryManager.items:
		var slot = item_slot_scene.instantiate()
		hbox.add_child(slot)
		slot.setup(item)
