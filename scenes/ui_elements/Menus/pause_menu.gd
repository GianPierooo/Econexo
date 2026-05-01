extends Control
class_name PauseMenu

func _ready() -> void:
	SceneManager.game_paused.connect(set_pause)

func set_pause():
	self.visible = true

func _on_continuar_pressed() -> void:
	self.visible = false
	SceneManager.pause_game(false)


func _on_volver_al_menú_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui_elements/Menus/MainMenu.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
