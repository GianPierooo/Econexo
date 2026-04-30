extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	DialogueManager.show_dialogue_balloon(
		load("res://dialogues/dialogue01.dialogue"),
        "start"
	)
