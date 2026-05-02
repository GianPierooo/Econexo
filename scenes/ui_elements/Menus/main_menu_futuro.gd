extends Control
class_name MainMenu

func _ready() -> void:
	get_tree().paused = true

func _on_start_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/hub/hub_main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_cambiar_tema_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui_elements/Menus/MainMenu.tscn")
