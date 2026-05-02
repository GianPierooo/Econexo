# cable_node.gd
extends Area2D

signal node_clicked(node)

enum State { INACTIVE, BROKEN, CONNECTED }

@export var state: State = State.BROKEN
@export var node_id: String = ""

@onready var sprite = $Sprite2D

func _ready():
	input_pickable = true
	_update_visual()

func set_state(new_state: State):
	state = new_state
	_update_visual()

func _update_visual():
	match state:
		State.INACTIVE:
			sprite.modulate = Color(0.5, 0.5, 0.5)  # gris
		State.BROKEN:
			sprite.modulate = Color(1.0, 0.2, 0.2)  # rojo
		State.CONNECTED:
			sprite.modulate = Color(0.2, 1.0, 0.2)  # verde

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Clic en nodo: ", node_id)
		emit_signal("node_clicked", self)
