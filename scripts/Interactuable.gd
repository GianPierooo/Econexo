# Interactable.gd
extends Area2D

@export var required_item: String = "llave"  # ítem necesario para interactuar

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var selected = InventoryManager.selected_item
		
		if selected.get("name") == required_item:
			_use_item()
		else:
			print("Necesitas el ítem correcto")

func _use_item():
	print("¡Usaste el ítem correctamente!")
	InventoryManager.remove_item(required_item)
	InventoryManager.selected_item = {}
	# Aquí pones lo que pasa: abrir puerta, revelar objeto, etc.
