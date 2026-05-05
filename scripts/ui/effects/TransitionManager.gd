# TransitionManager.gd
extends CanvasLayer

@onready var overlay = $Overlay

var sfx_pasos: Array = []
var player_pasos: AudioStreamPlayer

func _ready():
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Cargar sonidos de caminata
	player_pasos = AudioStreamPlayer.new()
	add_child(player_pasos)
	sfx_pasos = [
		load("res://assets/sounds/Econexo_Movimiento1.wav"),
		load("res://assets/sounds/Econexo_Movimiento2.wav"),
		load("res://assets/sounds/Econexo_Movimiento3.wav")
	]

func fade_to(scene_path: String, duration: float = 0.5):
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	TooltipUi.hide_tooltip()
	
	# Reproducir sonido de caminata aleatorio
	if not sfx_pasos.is_empty():
		player_pasos.stream = sfx_pasos[randi() % sfx_pasos.size()]
		player_pasos.play()
	
	# Fade a negro
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 1.0, duration)
	await tween.finished
	
	get_tree().change_scene_to_file(scene_path)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Fade desde negro
	var tween2 = create_tween()
	tween2.tween_property(overlay, "color:a", 0.0, duration)
	await tween2.finished
	
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
