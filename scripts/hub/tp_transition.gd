extends Node2D

@onready var fade_rect = $CanvasLayer/FadeRect

const NEXT_SCENE = "res://scenes/levels/level_01/lvl1_street_01.tscn"
const FADE_DURATION = 1.2

func _ready() -> void:
	fade_rect.modulate.a = 0.0
	await get_tree().process_frame
	await _play_dialogue()
	await _fade_to_black()
	get_tree().change_scene_to_file(NEXT_SCENE)

func _play_dialogue() -> void:
	var dialogue_resource = load("res://data/dialogues/hub/hub_tp_transition.dialogue")
	if dialogue_resource == null:
		push_error("No se encontró hub_tp_transition.dialogue")
		return
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")
	await balloon.tree_exited

func _fade_to_black() -> void:
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, FADE_DURATION)
	await tween.finished
	await get_tree().create_timer(0.3).timeout
