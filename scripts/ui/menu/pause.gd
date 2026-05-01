extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pausa"):
		get_tree().paused = true
