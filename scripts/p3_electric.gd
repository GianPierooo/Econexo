# p3_electric.gd
extends Node2D

@onready var node_fuente = $CableSystem/NodeFuente
@onready var node_a = $CableSystem/NodeA
@onready var node_b = $CableSystem/NodeB
@onready var node_c = $CableSystem/NodeC
@onready var node_salida = $CableSystem/NodeSalida
@onready var cable_lines = $CableLines
@onready var exit_zone = $ExitZone

var nodes_in_order: Array = []
var last_connected: int = 0

func _ready():
	print("=== DEBUG P3 ===")
	print("Hijos de GateElectric:")
	for child in get_children():
		print("  - ", child.name)
	
	print("Hijos de CableSystem:")
	for child in $CableSystem.get_children():
		print("  - ", child.name)
	
	print("node_fuente: ", node_fuente)
	print("node_a: ", node_a)
	print("================")
	
	if node_fuente == null:
		print("ERROR: node_fuente es null")
		return
	
	node_fuente.set_state(node_fuente.State.CONNECTED)
	nodes_in_order = [node_fuente, node_a, node_b, node_c, node_salida]
	
	node_a.node_clicked.connect(_on_node_clicked)
	node_b.node_clicked.connect(_on_node_clicked)
	node_c.node_clicked.connect(_on_node_clicked)
	
	exit_zone.visible = false
	cable_lines.update_lines(nodes_in_order)

func _on_node_clicked(node):
	var next_index = last_connected + 1
	if next_index >= nodes_in_order.size():
		return
	if node == nodes_in_order[next_index]:
		node.set_state(node.State.CONNECTED)
		last_connected = next_index
		print("✅ Nodo conectado: ", node.node_id)
		cable_lines.update_lines(nodes_in_order)
		_check_puzzle()
	else:
		print("❌ Conecta en orden")

func _check_puzzle():
	if last_connected == nodes_in_order.size() - 2:
		node_salida.set_state(node_salida.State.CONNECTED)
		cable_lines.update_lines(nodes_in_order)
		print("🎉 Circuito completo")
		_abrir_puerta()

func _abrir_puerta():
	exit_zone.visible = true
	print("Puerta abierta")
	FragmentManager.add_fragment("F3_lista_edificio")
