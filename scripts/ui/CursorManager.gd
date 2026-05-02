# CursorManager.gd
extends Node

var cursor_normal = preload("res://assets/ui/MouseIcon1-Pointer@0.5x.png")
var cursor_hover = preload("res://assets/ui/MouseIcon2-Hand@0.5x.png")


func _ready():
	set_normal()
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node):
	if node is Button or node is TextureButton:
		node.mouse_entered.connect(set_hover)
		node.mouse_exited.connect(set_normal)
	elif node is Area2D:
		node.mouse_entered.connect(set_hover)
		node.mouse_exited.connect(set_normal)

func set_normal():
	Input.set_custom_mouse_cursor(cursor_normal, Input.CURSOR_ARROW, Vector2(0, 0))

func set_hover():
	Input.set_custom_mouse_cursor(cursor_hover, Input.CURSOR_ARROW, Vector2(0, 0))
