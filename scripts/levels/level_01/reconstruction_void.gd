extends Node2D

@onready var pedestales = $Pedestales

const SCENE_NEXT = "res://scenes/hub/hub_main.tscn"

var fragmento_arrastrado = null
var fragmento_origen_slot = null
var pedestales_ocupados: int = 0
var total_pedestales: int = 5
var dialogue_playing: bool = false
var reconstruccion_completa: bool = false

func _ready() -> void:
	$NavigationArrows.setup(
	"res://scenes/levels/level_01/lvl1_radio_room.tscn",
    ""
)
	# Reposicionar InventoryUI abajo para esta escena
	if InventoryManager._inventory_ui_instance != null:
		var ui = InventoryManager._inventory_ui_instance
		var panel = ui.get_node("Panel")
		panel.position = Vector2((1920 - 560) / 2, 940)
	
	# Configurar pedestales
	for pedestal in pedestales.get_children():
		var slot = pedestal.get_node("FragmentoSlot")
		slot.visible = false
	
	await get_tree().process_frame
	await _play_dialogue("start")
	
	# Conectar slots del inventario para arrastre
	_conectar_slots_inventario()

func _conectar_slots_inventario():
	if InventoryManager._inventory_ui_instance == null:
		return
	var container = InventoryManager._inventory_ui_instance.get_node("Panel/VBoxContainer/HBoxContainer")
	for slot in container.get_children():
		if not slot.is_empty:
			slot.gui_input.connect(_on_slot_input.bind(slot))

func _on_slot_input(event: InputEvent, slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if slot.is_empty or fragmento_arrastrado != null:
				return
			_iniciar_arrastre(slot)

func _iniciar_arrastre(slot):
	fragmento_arrastrado = slot.fragment_data
	fragmento_origen_slot = slot
	print("🖐️ Arrastrando: ", fragmento_arrastrado["nombre"])

func _input(event):
	if fragmento_arrastrado == null:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Soltar el fragmento
			_intentar_soltar(get_global_mouse_position())

func _intentar_soltar(pos: Vector2):
	for pedestal in pedestales.get_children():
		if pedestal.get_node("CollisionShape2D") == null:
			continue
		# Verificar si el mouse está sobre este pedestal
		var espacio = pedestal.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = pos
		var resultado = espacio.intersect_point(query)
		for r in resultado:
			if r.collider == pedestal:
				_colocar_en_pedestal(pedestal)
				return
	
	# Si no cayó en ningún pedestal
	print("❌ No cayó en ningún pedestal")
	fragmento_arrastrado = null
	fragmento_origen_slot = null

func _colocar_en_pedestal(pedestal: Node):
	var slot = pedestal.get_node("FragmentoSlot")
	if slot.visible:
		# Pedestal ya ocupado
		fragmento_arrastrado = null
		fragmento_origen_slot = null
		return
	
	# Mostrar imagen del fragmento en el pedestal
	if fragmento_arrastrado.get("imagen", "") != "":
		slot.texture = load(fragmento_arrastrado["imagen"])
	slot.visible = true
	
	pedestales_ocupados += 1
	print("✅ Fragmento colocado: ", fragmento_arrastrado["nombre"], " | ", pedestales_ocupados, "/", total_pedestales)
	
	fragmento_arrastrado = null
	fragmento_origen_slot = null
	
	if pedestales_ocupados >= total_pedestales:
		await _completar_reconstruccion()

func _completar_reconstruccion():
	reconstruccion_completa = true
	await _play_dialogue("reconstruccion_completa")
	await _play_dialogue("cierre")
	await get_tree().create_timer(2.0).timeout
	_go_to_scene(SCENE_NEXT)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/reconstruction_void.dialogue"
	var res = load(path)
	if res == null:
		push_error("No se encontró: " + path)
		return
	dialogue_playing = true
	var balloon = DialogueManager.show_example_dialogue_balloon(res, title)
	await balloon.tree_exited
	dialogue_playing = false

func _go_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
