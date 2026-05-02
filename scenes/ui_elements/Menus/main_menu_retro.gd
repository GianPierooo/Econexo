extends Control
class_name MainMenuRetro

@onready var titulo = $TituloVer_aObj1

var fondos = [
	preload("res://assets/images/titulo_ver.a_obj_1.png"),
	preload("res://assets/images/titulo_ver.a_obj_2.png"),
	preload("res://assets/images/titulo_ver.a_obj_3.png")
]

func _ready() -> void:
	randomize()
	get_tree().paused = true
	
	var indice = randi() % fondos.size()
	titulo.texture = fondos[indice]

func _on_start_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/hub/hub_main.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_cambiar_tema_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui_elements/Menus/MainMenuFuture.tscn")
