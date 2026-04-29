extends Node

signal item_selected(item)
signal inventory_changed

var items: Array = []
var selected_item: Dictionary = {}

func add_item(item_data: Dictionary):
	items.append(item_data)
	emit_signal("inventory_changed")

func remove_item(item_name: String):
	for i in items.size():
		if items[i]["name"] == item_name:
			items.remove_at(i)
			break
	emit_signal("inventory_changed")

func select_item(item_data: Dictionary):
	selected_item = item_data
	emit_signal("item_selected", item_data)

func has_item(item_name: String) -> bool:
	for item in items:
		if item["name"] == item_name:
			return true
	return false
