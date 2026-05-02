# lvl1_receptionOFF.gd
extends Node2D

@onready var btn_volver = $BtnVolver

func _ready():
	btn_volver.pressed.connect(_on_volver)

func _on_volver():
	TransitionManager.fade_to("res://scenes/levels/level_01/lvl1_street_02.tscn")
