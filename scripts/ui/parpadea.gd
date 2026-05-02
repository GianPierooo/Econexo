# FlickerLight.gd
extends PointLight2D

@export var min_energy: float = 0.3
@export var max_energy: float = 1.8
@export var speed: float = 4.0

func _process(delta):
	energy = lerp(energy, randf_range(min_energy, max_energy), delta * speed)
