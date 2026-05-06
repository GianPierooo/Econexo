extends Node2D

@onready var radio = $Props/Radio
@onready var dial_ui = $CanvasLayer/DialUI
@onready var dial_wheel = $CanvasLayer/DialUI/DialWheel
@onready var radio_closeup = $CanvasLayer/DialUI/RadioClouseup
@onready var btn_cerrar = $CanvasLayer/DialUI/BtnCerrar


const SCENE_NEXT = "res://scenes/levels/level_01/reconstruction_void.tscn"

var radio_activa: bool = false
var dialogue_playing: bool = false
var puzzle_completado: bool = false
var dial_value: float = 0.5
var dial_rotation: float = 0.0
var zona_oficial: float = 0.2
var zona_colectiva: float = 0.8
var tolerancia: float = 0.08
var en_zona: String = ""
var tiempo_estable: float = 0.0
var tiempo_requerido: float = 2.0
var ultimo_dial_value: float = 0.5
var dial_moving: bool = false
var sfx_dial: AudioStreamPlayer

func _ready() -> void:
	# Crear el sfx por código
	sfx_dial = AudioStreamPlayer.new()
	add_child(sfx_dial)
	sfx_dial.stream = load("res://assets/sounds/Econexo_Movimiento1.wav")
	sfx_dial.volume_db = -5.0
	
	$NavigationArrows.setup(
		"res://scenes/levels/level_01/lvl1_alley.tscn",
		""
	)
	dial_ui.visible = false
	btn_cerrar.text = "✕"
	btn_cerrar.process_mode = Node.PROCESS_MODE_ALWAYS
	btn_cerrar.pressed.connect(_cerrar_radio)
	radio.input_event.connect(_on_radio_clicked)
	await get_tree().process_frame
	await _play_dialogue("start")

func _on_radio_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if dialogue_playing or radio_activa:
				return
			_activar_radio()

func _activar_radio():
	radio_activa = true
	dial_ui.visible = true
	radio_closeup.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(radio_closeup, "modulate:a", 1.0, 0.5)
	await tween.finished
	await _play_dialogue("radio_encendida")

func _cerrar_radio():
	if puzzle_completado:
		return
	var tween = create_tween()
	tween.tween_property(radio_closeup, "modulate:a", 0.0, 0.3)
	await tween.finished
	dial_ui.visible = false
	radio_activa = false
	en_zona = ""
	tiempo_estable = 0.0

func _process(delta):
	if not radio_activa or puzzle_completado or dialogue_playing:
		return
	
	if Input.is_action_pressed("ui_left"):
		dial_value = clamp(dial_value - delta * 0.25, 0.0, 1.0)
		dial_rotation -= delta * 90.0
	if Input.is_action_pressed("ui_right"):
		dial_value = clamp(dial_value + delta * 0.25, 0.0, 1.0)
		dial_rotation += delta * 90.0
	
	dial_wheel.pivot_offset = dial_wheel.size / 2
	dial_wheel.rotation_degrees = dial_rotation
	
	var zona_anterior = en_zona
	
	if abs(dial_value - zona_oficial) < tolerancia:
		en_zona = "oficial"
		dial_wheel.modulate = Color(1, 1, 1, 1)
	elif abs(dial_value - zona_colectiva) < tolerancia:
		en_zona = "colectiva"
		dial_wheel.modulate = Color(1, 0.9, 0.2, 1)
	else:
		en_zona = ""
		tiempo_estable = 0.0
		dial_wheel.modulate = Color(0.8, 0.8, 0.8, 1)
	
	if en_zona != "":
		if en_zona != zona_anterior:
			tiempo_estable = 0.0
			if en_zona == "oficial":
				_play_dialogue_no_await("senal_oficial_hint")
			else:
				_play_dialogue_no_await("senal_colectiva_hint")
		tiempo_estable += delta
		if tiempo_estable >= tiempo_requerido:
			_estabilizar_senal(en_zona)
	
	var moving = false
	if Input.is_action_pressed("ui_left"):
		dial_value = clamp(dial_value - delta * 0.25, 0.0, 1.0)
		dial_rotation -= delta * 90.0
		moving = true
	if Input.is_action_pressed("ui_right"):
		dial_value = clamp(dial_value + delta * 0.25, 0.0, 1.0)
		dial_rotation += delta * 90.0
		moving = true

func _play_dialogue_no_await(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_radio_room.dialogue"
	var res = load(path)
	if res == null:
		return
	DialogueManager.show_dialogue_balloon(res, title)

func _estabilizar_senal(zona: String):
	puzzle_completado = true
	var tween = create_tween()
	tween.tween_property(radio_closeup, "modulate:a", 0.0, 0.5)
	await tween.finished
	dial_ui.visible = false
	
	if zona == "oficial":
		await _play_dialogue("senal_oficial")
		await _play_dialogue("cierre_oficial")
	else:
		await _play_dialogue("senal_colectiva_1")
		await _play_dialogue("senal_colectiva_2")
		await _play_dialogue("senal_colectiva_3")
		await _play_dialogue("senal_colectiva_4")
		await _play_dialogue("cierre_colectiva")
	
	FragmentManager.add_fragment("F5_radio")
	$NavigationArrows.setup(
		"res://scenes/levels/level_01/lvl1_alley.tscn",
		SCENE_NEXT
	)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_radio_room.dialogue"
	var res = load(path)
	if res == null:
		push_error("No se encontró: " + path)
		return
	dialogue_playing = true
	var balloon = DialogueManager.show_dialogue_balloon(res, title)
	await balloon.tree_exited
	dialogue_playing = false
