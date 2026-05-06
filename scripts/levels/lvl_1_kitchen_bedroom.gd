extends Node2D

@onready var scan_overlay = $ScanOverlay/ColorRect

const SCENE_NEXT = "res://scenes/levels/level_01/lvl1_alley.tscn"

var cajon_activo: bool = false
var cajon_abierto: bool = false
var scanning: bool = false
var dialogue_playing: bool = false
var cajon: Node = null

func _ready() -> void:
	$NavigationArrows.setup(
		"res://scenes/levels/level_01/lvl1_livingroom.tscn",
		"res://scenes/levels/level_01/lvl1_container_puzzle.tscn"
	)
	
	scan_overlay.visible = false
	scan_overlay.color = Color(0, 0.8, 1, 0.0)
	
	# Buscar cajón de forma segura
	cajon = get_node_or_null("Props/Cajon")
	if cajon == null:
		push_error("No se encontró Props/Cajon en la escena")
	else:
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
	if cajon:
		cajon.input_pickable = true
	await _play_dialogue("cajon_activado")

func _abrir_cajon():
	if cajon_abierto:
		return
	cajon_abierto = true
	await _play_dialogue("cajon_abierto")
	await _play_dialogue("foto_bebe")
	await _play_dialogue("diario")
	await _play_dialogue("cierre")
	FragmentManager.add_fragment("F2_diario")
	# Habilitar navegación manual
	$NavigationArrows.setup(
		"res://scenes/levels/level_01/lvl1_livingroom.tscn",
		SCENE_NEXT
	)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_kitchen_bedroom.dialogue"
	var res = load(path)
	if res == null:
		push_error("No se encontró: " + path)
		return
	dialogue_playing = true
	var balloon = DialogueManager.show_dialogue_balloon(res, title)
	await balloon.tree_exited
	dialogue_playing = false
