extends Control
class_name MainMenu

@onready var titulo = $TituloVer_aObj1

var fondos = [
	preload("res://assets/images/menu/titulo_ver.f_obj_1.png"),
	preload("res://assets/images/menu/titulo_ver.f_obj_2.png"),
	preload("res://assets/images/menu/titulo_ver.f_obj_3.png")
]

var _tree: SceneTree

func _ready() -> void:
	_tree = get_tree()
	randomize()
	var indice = randi() % fondos.size()
	titulo.texture = fondos[indice]

func _on_start_pressed() -> void:
	_tree.change_scene_to_file("res://scenes/hub/hub_main.tscn")

func _on_exit_pressed() -> void:
	_tree.quit()

func _on_cambiar_tema_pressed() -> void:
	_tree.change_scene_to_file("res://scenes/ui_elements/Menus/MainMenu.tscn")
