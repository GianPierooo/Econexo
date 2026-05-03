# NavigationArrow.gd
extends Area2D

signal arrow_clicked

@export var target_scene: String = ""
@export var direction: String = "right"
@export var tooltip_text: String = "Caminar"  # ← exportable para cambiar en el inspector

@onready var sprite = $Sprite2D

func _ready():
	input_pickable = true
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if target_scene != "":
			TooltipUi.hide_tooltip()
			TransitionManager.fade_to(target_scene)

func _on_hover():
	TooltipUi.show_tooltip(tooltip_text)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.6, 0.2)

func _on_exit():
	TooltipUi.hide_tooltip()
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.2)
