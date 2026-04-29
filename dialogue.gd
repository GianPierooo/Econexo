extends Node2D

var balloon_scene = preload("res://dialogues/balloon.tscn")

func show_dialogue():
	var balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)

func _ready() -> void:
	show_dialogue()

func _process(delta: float) -> void:
	pass
