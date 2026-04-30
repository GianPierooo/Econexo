extends Area2D

signal clicked

func _ready() -> void:
	input_pickable = true

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print(name, " clickeado")
		clicked.emit()
