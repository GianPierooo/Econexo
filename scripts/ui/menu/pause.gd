extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pausa"):
		SceneManager.pause_game(true)
