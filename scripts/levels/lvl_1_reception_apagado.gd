# lvl1_receptionOFF.gd
extends Node2D

@onready var btn_volver = $BtnVolver

func _ready():
	btn_volver.pressed.connect(_on_volver)
	btn_volver.mouse_entered.connect(CursorManager.set_hover)
	btn_volver.mouse_exited.connect(CursorManager.set_normal)

func _on_volver():
	TransitionManager.fade_to("res://scenes/levels/level_01/lvl1_street_02.tscn")
