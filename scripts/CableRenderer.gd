# CableRenderer.gd
extends Node2D

var cables: Array = []
var dragging_cable = null  # cable que se está arrastrando ahora

func _draw():
	# Dibujar cables conectados
	for cable in cables:
		_draw_curve(cable.from, cable.to, cable.color, 6.0)
	
	# Dibujar cable en arrastre
	if dragging_cable:
		_draw_curve(
			dragging_cable.from,
			get_global_mouse_position(),
			dragging_cable.color,
			4.0
		)

func _draw_curve(from: Vector2, to: Vector2, color: Color, width: float):
	# Convertir a coordenadas locales
	var p0 = to_local(from)
	var p3 = to_local(to)
	
	# Puntos de control para curva bezier
	var p1 = p0 + Vector2(200, 0)   # sale hacia la derecha
	var p2 = p3 + Vector2(-200, 0)  # llega desde la izquierda
	
	# Dibujar bezier con segmentos
	var prev = p0
	for i in 20:
		var t = (i + 1) / 20.0
		var point = _bezier(p0, p1, p2, p3, t)
		draw_line(prev, point, color, width, true)
		prev = point

func _bezier(p0, p1, p2, p3, t) -> Vector2:
	var u = 1 - t
	return u*u*u*p0 + 3*u*u*t*p1 + 3*u*t*t*p2 + t*t*t*p3

func start_drag(from_pos: Vector2, color: Color):
	dragging_cable = { "from": from_pos, "color": color }

func stop_drag():
	dragging_cable = null

func add_cable(from: Vector2, to: Vector2, color: Color):
	cables.append({ "from": from, "to": to, "color": color })

func _process(_delta):
	if dragging_cable:
		queue_redraw()
