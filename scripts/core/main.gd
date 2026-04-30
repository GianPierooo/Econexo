extends Node

@onready var world = $World
@onready var dialogue_layer = $UILayer/UI/DialogueLayer
@onready var hud_layer = $UILayer/UI/HUDLayer
@onready var fade_layer = $UILayer/UI/FadeLayer

func _ready() -> void:
	load_scene("res://scenes/levels/level_01/level_01_main.tscn")

func load_scene(path: String) -> void:
	for child in world.get_children():
		child.queue_free()

	var scene = load(path).instantiate()
	world.add_child(scene)
