extends Node2D

@onready var fade_rect = $CanvasLayer/FadeRect
@onready var sprite_tp =  $Sprite2D

const NEXT_SCENE = "res://scenes/levels/level_01/lvl1_street_01.tscn"
const FADE_DURATION = 1.2

func _ready() -> void:
	fade_rect.modulate.a = 0.0
	await get_tree().process_frame
	await _play_dialogue()
	# En vez de fade_to_black + change_scene, llama activar_tp del sprite
	await sprite_tp.activar_tp()

func _play_dialogue() -> void:
	var dialogue_resource = load("res://data/dialogues/hub/hub_tp_transition.dialogue")
	if dialogue_resource == null:
		push_error("No se encontró hub_tp_transition.dialogue")
		return
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")
	await balloon.tree_exited
