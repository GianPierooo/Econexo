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
	
	if not terminal.clicked.is_connected(_on_terminal_clicked):
		terminal.clicked.connect(_on_terminal_clicked)
	if not portal.clicked.is_connected(_on_portal_clicked):
		portal.clicked.connect(_on_portal_clicked)
	
	start_intro()

func start_intro() -> void:
	var dialogue_resource = load("res://data/dialogues/hub/hub_intro.dialogue")
	
	if dialogue_resource == null:
		push_error("No se encontró hub_intro.dialogue")
		intro_finished = true
		enable_hub_interaction()
		return
	
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
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
		await _play_dialogue("res://data/dialogues/hub/hub_terminal_done.dialogue")
	else:
		await _play_dialogue("res://data/dialogues/hub/hub_terminal_activate.dialogue")
		activate_portal()

func _on_portal_clicked() -> void:
	if not intro_finished or dialogue_playing:
		return
	
	if portal_activated:
		go_to_transition()
	else:
		await _play_dialogue("res://data/dialogues/hub/hub_portal_inactive.dialogue")

func activate_portal() -> void:
	if portal_activated:
		return
	portal_activated = true
	portal_off.visible = false
	portal_on.visible = true

func go_to_transition() -> void:
	await _play_dialogue("res://data/dialogues/hub/hub_tp_transition.dialogue")
	TransitionManager.fade_to("res://scenes/hub/tp_transition.tscn")

func _play_dialogue(path: String) -> void:
	var dialogue_resource = load(path)
	if dialogue_resource == null:
		push_error("No se encontró: " + path)
		return
	
	dialogue_playing = true
	terminal.input_pickable = false
	portal.input_pickable = false
	
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, "start")
	await balloon.tree_exited
	
	dialogue_playing = false
	terminal.input_pickable = true
	portal.input_pickable = true
