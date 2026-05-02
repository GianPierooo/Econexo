extends Node2D

@onready var cajon = $Props/Cajon
@onready var scan_overlay = $ScanOverlay/ColorRect

const SCENE_NEXT = "res://scenes/levels/level_01/lvl1_alley.tscn"

var cajon_activo: bool = false
var cajon_abierto: bool = false
var scanning: bool = false
var dialogue_playing: bool = false

func _ready() -> void:
	scan_overlay.visible = false
	scan_overlay.color = Color(0, 0.8, 1, 0.0)
	cajon.input_pickable = false
	await get_tree().process_frame
	await _play_dialogue("start")

func _input(event):
	if event.is_action_pressed("scan"):
		if dialogue_playing:
			return
		_activate_scan()

func _activate_scan():
	if scanning:
		return
	scanning = true
	
	var tween = create_tween()
	tween.tween_property(scan_overlay, "color", Color(0, 0.8, 1, 0.08), 0.3)
	scan_overlay.visible = true
	
	await get_tree().create_timer(1.5).timeout
	
	if FragmentManager.tiene_fragmento("F1_foto_familiar") and not cajon_abierto:
		await _activar_cajon()
		# Directamente abre el cajón sin necesitar click
		await _abrir_cajon()
	else:
		await _play_dialogue("sin_f1")
	
	var tween2 = create_tween()
	tween2.tween_property(scan_overlay, "color", Color(0, 0.8, 1, 0.0), 0.3)
	await tween2.finished
	scan_overlay.visible = false
	scanning = false

func _activar_cajon():
	if cajon_activo:
		return
	cajon_activo = true
	await _play_dialogue("cajon_activado")

func _on_cajon_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if cajon_abierto:
				return
			_abrir_cajon()

func _abrir_cajon():
	cajon_abierto = true
	await _play_dialogue("cajon_abierto")
	await _play_dialogue("foto_bebe")
	await _play_dialogue("diario")
	await _play_dialogue("cierre")
	FragmentManager.add_fragment("F2_diario")
	await get_tree().create_timer(2.0).timeout
	_go_to_scene(SCENE_NEXT)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_kitchen_bedroom.dialogue"
	var res = load(path)
	if res == null:
		push_error("No se encontró: " + path)
		return
	dialogue_playing = true
	var balloon = DialogueManager.show_example_dialogue_balloon(res, title)
	await balloon.tree_exited
	dialogue_playing = false

func _go_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
