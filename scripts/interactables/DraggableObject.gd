extends Area2D
signal clicked
signal clicked_after_placed  # ← señal nueva para click después de colocar

@export var snap_distance: float = 500.0
@export var target_path: NodePath

var target_node: Node2D
var dragging: bool = false
var original_position: Vector2
var offset: Vector2
var is_placed: bool = false

func _ready():
	original_position = position
	if target_path:
		target_node = get_node(target_path)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_placed:
				# Ya colocado: emitir señal de click
				clicked_after_placed.emit()
				return
			dragging = true
			offset = global_position - get_global_mouse_position()
			get_viewport().set_input_as_handled()

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
		push_error("target_node es null en: " + name)
		return
	var my_pos = position
	var target_pos = target_node.position
	var distancia = my_pos.distance_to(target_pos)
	if distancia <= snap_distance:
		position = target_pos
		is_placed = true
		emit_signal("clicked")  # ← se emite al snapear
		set_process(false)
	else:
		position = original_position
