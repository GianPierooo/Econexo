extends Node2D

@onready var portal_off = $PortalOff
@onready var portal_on = $PortalOn
@onready var terminal = $Hotspots/Terminal
@onready var portal = $Hotspots/Portal

var intro_finished: bool = false
var portal_activated: bool = false
var dialogue_playing: bool = false

func _ready() -> void:
	await get_tree().process_frame
	
	portal_on.visible = false
	portal_off.visible = true
	
	terminal.input_pickable = false
	portal.input_pickable = false
	
	terminal.clicked.connect(_on_terminal_clicked)
	portal.clicked.connect(_on_portal_clicked)
	
	start_intro()

func start_intro() -> void:
	var dialogue_resource = load("res://data/dialogues/hub/hub_intro.dialogue")
	
	if dialogue_resource == null:
		push_error("No se encontró hub_intro.dialogue")
		intro_finished = true
		enable_hub_interaction()
		return
	
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")
	await balloon.tree_exited
	
	intro_finished = true
	enable_hub_interaction()

func enable_hub_interaction() -> void:
	terminal.input_pickable = true
	portal.input_pickable = true

func _on_terminal_clicked() -> void:
	if not intro_finished or dialogue_playing:
		return
	
	if portal_activated:
		# Ya fue activado antes, NX-0 recuerda
		_play_dialogue("res://data/dialogues/hub/hub_terminal_done.dialogue")
	else:
		# Primera vez: diálogo y enciende el portal al terminar
		await _play_dialogue("res://data/dialogues/hub/hub_terminal_activate.dialogue")
		activate_portal()

func _on_portal_clicked() -> void:
	if not intro_finished or dialogue_playing:
		return
	
	if portal_activated:
		# Portal encendido: el jugador entra
		go_to_transition()
	else:
		# Portal apagado: NX-0 indica que hay que usar el terminal
		_play_dialogue("res://data/dialogues/hub/hub_portal_inactive.dialogue")

func activate_portal() -> void:
	if portal_activated:
		return
	portal_activated = true
	portal_off.visible = false
	portal_on.visible = true

func go_to_transition() -> void:
	get_tree().change_scene_to_file("res://scenes/hub/tp_transition.tscn")

# Helper: reproduce un diálogo y bloquea interacción mientras dura
func _play_dialogue(path: String) -> void:
	var dialogue_resource = load(path)
	if dialogue_resource == null:
		push_error("No se encontró: " + path)
		return
	
	dialogue_playing = true
	terminal.input_pickable = false
	portal.input_pickable = false
	
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")
	await balloon.tree_exited
	
	dialogue_playing = false
	terminal.input_pickable = true
	portal.input_pickable = true
