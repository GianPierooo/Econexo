# cable_lines.gd
extends Node2D

var connections: Array = []  # lista de pares de posiciones

func update_lines(nodes: Array):
	connections = []
	for i in nodes.size() - 1:
		connections.append({
			"from": nodes[i].global_position,
			"to": nodes[i + 1].global_position,
			"connected": nodes[i + 1].state == nodes[i + 1].State.CONNECTED
		})
	queue_redraw()

func _draw():
	for conn in connections:
		var color = Color(0.1, 0.8, 0.1) if conn["connected"] else Color(0.8, 0.1, 0.1)
		draw_line(
			to_local(conn["from"]),
			to_local(conn["to"]),
			color,
			3.0
		)
