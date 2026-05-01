extends Node2D

@onready var silla = $Props/Silla
@onready var plato = $Props/Plato
@onready var radio = $Props/Radio
@onready var marco = $Props/Marco

var props_placed: int = 0
var total_props: int = 4
var puzzle_completed: bool = false
var dialogue_playing: bool = false
var f1_unlocked: bool = false

const SCENE_NEXT = "res://scenes/levels/level_01/lvl1_kitchen_bedroom.tscn"

func _ready() -> void:
	await get_tree().process_frame
	
	silla.clicked.connect(_on_prop_placed.bind("silla"))
	plato.clicked.connect(_on_prop_placed.bind("plato"))
	radio.clicked.connect(_on_prop_placed.bind("radio"))
	marco.clicked.connect(_on_prop_placed.bind("marco"))
	
	await _play_dialogue("start")
func _on_prop_placed(prop_name: String) -> void:
	if puzzle_completed:
		return
	props_placed += 1
	print("✅ Prop colocado: ", prop_name, " | Total: ", props_placed, "/", total_props)
	await _play_dialogue(prop_name + "_placed")
	if props_placed >= total_props:
		print("🎯 Puzzle completo! Llamando _complete_puzzle")
		await _complete_puzzle()

func _complete_puzzle() -> void:
	puzzle_completed = true
	print("🔓 _complete_puzzle ejecutado")
	await _play_dialogue("puzzle_complete")
	_unlock_f1()

func _unlock_f1() -> void:
	f1_unlocked = true
	marco.clicked.disconnect(_on_prop_placed)
	marco.clicked_after_placed.connect(_on_marco_clicked)  # ← cambiá esto
	await _play_dialogue("f1_hint")

func _on_marco_clicked() -> void:
	print("🖼️ Marco clickeado! f1_unlocked=", f1_unlocked)
	if dialogue_playing or not f1_unlocked:
		return
	await _play_dialogue("f1_inspect")
	
	# Agregar al FragmentManager y al InventoryManager
	FragmentManager.add_fragment("F1_foto_familiar")
	InventoryManager.add_item({
		"name": "F1_foto_familiar",
		"display_name": "Foto Familiar",
		"icon": null  # reemplazá con la ruta del ícono si tenés
	})
	
	await _play_dialogue("f1_close")
	
	# Esperar 2 segundos antes de cambiar de escena
	await get_tree().create_timer(2.0).timeout
	_go_to_scene(SCENE_NEXT)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_livingroom.dialogue"
	var res = load(path)
	if res == null:
		push_error("No se encontró: " + path)
		return
	dialogue_playing = true
	var balloon = DialogueManager.show_example_dialogue_balloon(res, title)
	await balloon.tree_exited
	dialogue_playing = false

func _go_to_scene(path: String) -> void:
	# Asegurarse que el UI del inventario siga vivo
	if InventoryManager._inventory_ui_instance != null:
		InventoryManager._inventory_ui_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().change_scene_to_file(path)
