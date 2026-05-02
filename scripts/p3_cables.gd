# p3_cables.gd
extends Node2D

@onready var cable_renderer = $Renderer
@onready var ports_left = $PortLeft
@onready var ports_right = $PortRight

var dragging_from = null
var connections_made: int = 0
const TOTAL_CONNECTIONS: int = 4
const SNAP_DISTANCE: float = 60.0

func _ready():
	for port in ports_left.get_children():
		if port.has_signal("drag_started"):
			port.drag_started.connect(_on_drag_started)
	
	for port in ports_right.get_children():
		if port.has_method("activate_hover"):
			port.mouse_entered.connect(func(): port.activate_hover())
			port.mouse_exited.connect(func(): port.deactivate_hover())

func _on_drag_started(port):
	dragging_from = port
	cable_renderer.start_drag(port.global_position, port.color)
	print("Arrastrando: ", port.color_id)

func _input(event):
	if dragging_from == null:
		return
	if event is InputEventMouseButton:
		if not event.pressed:
			_try_connect(get_global_mouse_position())

func _try_connect(mouse_pos: Vector2):
	cable_renderer.stop_drag()
	var closest_port = null
	var closest_dist = SNAP_DISTANCE
	
	for port in ports_right.get_children():
		var dist = mouse_pos.distance_to(port.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_port = port
	
	if closest_port != null:
		if closest_port.color_id == dragging_from.color_id:
			_make_connection(dragging_from, closest_port)
		else:
			print("❌ Color incorrecto")
			_flash_error(closest_port)
	
	dragging_from = null

func _make_connection(left_port, right_port):
	left_port.set_connected()
	right_port.set_connected()
	cable_renderer.add_cable(
		left_port.global_position,
		right_port.global_position,
		left_port.color
	)
	connections_made += 1
	print("✅ Conectado: ", left_port.color_id)
	
	if connections_made >= TOTAL_CONNECTIONS:
		_puzzle_complete()

func _flash_error(port):
	port.sprite.modulate = Color.WHITE
	await get_tree().create_timer(0.3).timeout
	port.deactivate_hover()

func _puzzle_complete():
	print("🎉 Puzzle completado")
	FragmentManager.add_fragment("F3_lista_edificio")
	await get_tree().create_timer(1.0).timeout
	TransitionManager.fade_to("res://scenes/levels/level_01/rooms/lvl1_reception.tscn")
