# DraggableObject.gd
extends Area2D

signal clicked

@export var snap_distance: float = 150.0
@export var target_path: NodePath

var target_node: Node2D
var dragging: bool = false
var original_position: Vector2
var offset: Vector2

func _ready():
	original_position = global_position
	if target_path:
		target_node = get_node(target_path)

# Solo detecta el INICIO del arrastre (cuando el mouse está sobre el objeto)
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			offset = global_position - get_global_mouse_position()
			get_viewport().set_input_as_handled()

# Detecta TODO lo demás globalmente (movimiento y soltar)
func _input(event):
	if not dragging:
		return
	
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false
			_check_snap()

func _check_snap():
	if target_node == null:
		print("ERROR: target_node es null, revisa el Target Path en el inspector")
		return
	
	var distancia = global_position.distance_to(target_node.global_position)
	print("Distancia al target: ", distancia)  # para debug
	
	if distancia <= snap_distance:
		global_position = target_node.global_position
		emit_signal("clicked")
		set_process(false)
		print("✅ Objeto encajó!")
	else:
		global_position = original_position
		print("❌ Muy lejos, volviendo. Distancia era: ", distancia)
