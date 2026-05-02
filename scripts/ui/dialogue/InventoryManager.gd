extends Node

signal item_selected(item)
signal inventory_changed

var items: Array = []
var selected_item: Dictionary = {}

var _inventory_ui_scene = preload("res://scenes/ui_elements/inventory/InventoryUI.tscn")
var _inventory_ui_instance = null

func _ready():
	get_tree().connect("node_removed", _on_node_removed)
	FragmentManager.fragmento_agregado.connect(_on_fragmento_agregado)
	print("✅ InventoryManager listo, conectado a FragmentManager")

func _on_fragmento_agregado(fragmento):
	print("📦 InventoryManager recibió fragmento: ", fragmento["nombre"])
	_show_inventory_ui()



func _on_node_removed(node: Node):
	if node == _inventory_ui_instance:
		_inventory_ui_instance = null

func _show_inventory_ui():
	print("🖥️ _show_inventory_ui llamado, instancia actual: ", _inventory_ui_instance)
	if _inventory_ui_instance == null:
		_inventory_ui_instance = _inventory_ui_scene.instantiate()
		get_tree().root.add_child(_inventory_ui_instance)
		_inventory_ui_instance.process_mode = Node.PROCESS_MODE_ALWAYS
		print("✅ InventoryUI creado")
	else:
		print("⚠️ InventoryUI ya existe")

func add_item(item_data: Dictionary):
	items.append(item_data)
	_show_inventory_ui()
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
