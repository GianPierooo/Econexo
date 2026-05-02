# lvl1_street_02.gd
extends Node2D

@onready var puerta = $Hotspots/Puerta
@onready var panel = $Hotspots/PanelElectrico
@onready var ventana = $Hotspots/Ventana
@onready var cam = $Camera2D

var dialogues = preload("res://data/dialogues/level_01/p3_dialogues.dialogue")

func _ready():
	puerta.input_event.connect(_on_puerta_clicked)
	panel.input_event.connect(_on_panel_clicked)
	ventana.input_event.connect(_on_ventana_clicked)

func _on_puerta_clicked(_viewport, event, _shape):
	if not event is InputEventMouseButton or not event.pressed:
		return
	if FragmentManager.energia_activa:
		await DialogueManager.show_dialogue_balloon(dialogues, "puerta_abierta")
		TransitionManager.fade_to("res://scenes/levels/level_0/lvl1_receptionPrendido.tscn")
	else:
		await DialogueManager.show_dialogue_balloon(dialogues, "sin_energia")

func _on_panel_clicked(_viewport, event, _shape):
	if not event is InputEventMouseButton or not event.pressed:
		return
	if FragmentManager.energia_activa:
		await DialogueManager.show_dialogue_balloon(dialogues, "energia_ya_activa")
		return
	await DialogueManager.show_dialogue_balloon(dialogues, "intentando_activar")
	await _zoom_then_go("res://scenes/levels/level_01/lvl1_gate_electric2.tscn")

func _on_ventana_clicked(_viewport, event, _shape):
	if not event is InputEventMouseButton or not event.pressed:
		return
	if FragmentManager.energia_activa:
		TransitionManager.fade_to("res://scenes/levels/level_0/lvl1_receptionPrendido.tscn")
	else:
		TransitionManager.fade_to("res://scenes/levels/level_01/lvl1_receptionApagado.tscn")

func _zoom_then_go(scene_path: String):
	var tween = create_tween()
	tween.tween_property(cam, "zoom", Vector2(1.5, 1.5), 0.4)
	await tween.finished
	await get_tree().create_timer(0.3).timeout
	TransitionManager.fade_to(scene_path)
