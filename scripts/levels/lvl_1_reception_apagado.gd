# lvl1_reception_apagado.gd
extends Node2D

@onready var btn_volver = $BtnVolver

func _ready():
	btn_volver.pressed.connect(_on_volver)
	
	# Conectar cursor solo si no está ya conectado
	if not btn_volver.mouse_entered.is_connected(CursorManager.set_hover):
		btn_volver.mouse_entered.connect(CursorManager.set_hover)
	if not btn_volver.mouse_exited.is_connected(CursorManager.set_normal):
		btn_volver.mouse_exited.connect(CursorManager.set_normal)

func _on_volver():
	TransitionManager.fade_to("res://scenes/levels/level_01/lvl1_street_02.tscn")
