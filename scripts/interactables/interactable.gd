# Interactable.gd
extends Area2D

signal clicked

@export var tooltip_text: String = ""

var highlight: ColorRect

func _ready() -> void:
	input_pickable = true
	
	# Crear highlight visual
	highlight = ColorRect.new()
	highlight.color = Color(1.0, 1.0, 0.8, 0.02)  # blanco cálido muy sutil
	highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	highlight.visible = false
	
	# Ajustar tamaño al collision shape
	await get_tree().process_frame
	var shape = get_node_or_null("CollisionShape2D")
	if shape and shape.shape:
		var extents = shape.shape.get_rect().size
		highlight.size = extents
		highlight.position = shape.position - extents / 2
	
	add_child(highlight)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)

func _on_hover():
	TooltipUi.show_tooltip(tooltip_text)
	CursorManager.set_hover()
	highlight.visible = true

func _on_exit():
	TooltipUi.hide_tooltip()
	CursorManager.set_normal()
	highlight.visible = false

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit()
