# TransitionManager.gd
extends CanvasLayer

@onready var overlay = $Overlay

func _ready():
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_to(scene_path: String, duration: float = 0.5):
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	TooltipUi.hide_tooltip()
	
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 1.0, duration)
	await tween.finished
	
	get_tree().change_scene_to_file(scene_path)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var tween2 = create_tween()
	tween2.tween_property(overlay, "color:a", 0.0, duration)
	await tween2.finished
	
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
