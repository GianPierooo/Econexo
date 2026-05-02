# cable_node.gd
extends Area2D

signal node_clicked(node)

enum State { INACTIVE, BROKEN, CONNECTED }

@export var state: State = State.BROKEN
@export var node_id: String = ""

func _ready():
	# Crear un rectángulo de color temporal para ver el nodo
	var rect = ColorRect.new()
	rect.size = Vector2(50, 50)
	rect.position = Vector2(-25, -25)
	add_child(rect)
	_update_visual(rect)
	
	# Crear CollisionShape si no existe
	if get_node_or_null("CollisionShape2D") == null:
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		circle.radius = 30
		shape.shape = circle
		add_child(shape)

func set_state(new_state: State):
	state = new_state
	# Actualizar color del rect
	for child in get_children():
		if child is ColorRect:
			_update_visual(child)

func _update_visual(rect: ColorRect):
	match state:
		State.INACTIVE:
			rect.color = Color(0.5, 0.5, 0.5)
		State.BROKEN:
			rect.color = Color(0.8, 0.1, 0.1)
		State.CONNECTED:
			rect.color = Color(0.1, 0.8, 0.1)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("node_clicked", self)
