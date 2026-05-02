# tp_effect.gd
extends Sprite2D

@onready var material_shader = material

func _ready():
	# Empezar con intensidad 0
	material.set_shader_parameter("intensity", 0.0)
	
	# Animación de entrada
	var tween = create_tween()
	tween.tween_method(
		func(v): material.set_shader_parameter("intensity", v),
		0.0, 0.3, 1.5
	)

func activar_tp():
	# Animación de salida (más intensa)
	var tween = create_tween()
	tween.tween_method(
		func(v): material.set_shader_parameter("intensity", v),
		0.3, 1.0, 0.8
	)
	await tween.finished
	TransitionManager.fade_to("res://scenes/levels/level_01/lvl1_street_01.tscn")
