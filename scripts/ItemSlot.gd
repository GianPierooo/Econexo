# ItemSlot.gd
extends Button

var item_data: Dictionary = {}

func setup(data: Dictionary):
	item_data = data
	$TextureRect.texture = load(data["icon_path"])
	$Label.text = data["name"]

func _pressed():
	InventoryManager.select_item(item_data)
