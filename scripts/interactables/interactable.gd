# Interactable.gd
extends Area2D

signal clicked

@export var tooltip_text: String = ""

func _ready() -> void:
	input_pickable = true
	mouse_entered.connect(func(): TooltipUi.show_tooltip(tooltip_text))
	mouse_exited.connect(func(): TooltipUi.hide_tooltip())

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print(name, " clickeado")
		clicked.emit()
