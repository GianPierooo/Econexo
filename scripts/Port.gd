# Port.gd
extends Area2D

signal drag_started(port)
signal dropped_on(port)

@export var color_id: String = ""   # "rojo", "azul", "amarillo", "rosa"
@export var is_left: bool = true    # true = izquierda, false = derecha
@export var color: Color = Color.RED

@onready var sprite = $Sprite2D

var is_connected: bool = false

func _ready():
	input_pickable = true
	sprite.modulate = color

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if is_left and not is_connected:
			emit_signal("drag_started", self)

func activate_hover():
	sprite.modulate = color.lightened(0.3)

func deactivate_hover():
	sprite.modulate = color

func set_connected():
	is_connected = true
	sprite.modulate = color
