extends Node

signal item_selected(item)
signal inventory_changed

var items: Array = []
var selected_item: Dictionary = {}

var _inventory_ui_scene = preload("res://scenes/ui_elements/inventory/InventoryUI.tscn")
var _inventory_ui_instance = null

func _ready():
	get_tree().connect("node_removed", _on_node_removed)

func _on_node_removed(node: Node):
	if node == _inventory_ui_instance:
		_inventory_ui_instance = null

func add_item(item_data: Dictionary):
	items.append(item_data)
	_show_inventory_ui()
	emit_signal("inventory_changed")

func _show_inventory_ui():
	if _inventory_ui_instance == null:
		_inventory_ui_instance = _inventory_ui_scene.instantiate()
		get_tree().root.add_child(_inventory_ui_instance)
		_inventory_ui_instance.process_mode = Node.PROCESS_MODE_ALWAYS

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
