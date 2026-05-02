extends Node2D

@onready var radio = $Props/Radio
@onready var dial_ui = $CanvasLayer/DialUI
@onready var slider_bg = $CanvasLayer/DialUI/SliderBG
@onready var dial_indicator = $CanvasLayer/DialUI/DialIndicator

const SCENE_NEXT = "res://scenes/levels/level_01/reconstruction_void.tscn"

var radio_activa: bool = false
var dialogue_playing: bool = false
var puzzle_completado: bool = false
var dial_value: float = 0.0
var zona_oficial: float = 0.2
var zona_colectiva: float = 0.8
var tolerancia: float = 0.08
var en_zona: String = ""
var tiempo_estable: float = 0.0
var tiempo_requerido: float = 2.0

func _ready() -> void:
	$NavigationArrows.setup(
	"res://scenes/levels/level_01/lvl1_alley.tscn",
    "res://scenes/levels/level_01/reconstruction_void.tscn"
)
	dial_ui.visible = false
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
	await _play_dialogue("radio_encendida")

func _process(delta):
	if not radio_activa or puzzle_completado or dialogue_playing:
		return
	
	if Input.is_action_pressed("ui_left"):
		dial_value = clamp(dial_value - delta * 0.3, 0.0, 1.0)
	if Input.is_action_pressed("ui_right"):
		dial_value = clamp(dial_value + delta * 0.3, 0.0, 1.0)
	
	var slider_width = slider_bg.size.x - dial_indicator.size.x
	dial_indicator.position.x = slider_bg.position.x + slider_width * dial_value
	
	var zona_anterior = en_zona
	
	if abs(dial_value - zona_oficial) < tolerancia:
		en_zona = "oficial"
		dial_indicator.color = Color(1, 1, 1, 1)
	elif abs(dial_value - zona_colectiva) < tolerancia:
		en_zona = "colectiva"
		dial_indicator.color = Color(1, 0.9, 0.2, 1)
	else:
		en_zona = ""
		tiempo_estable = 0.0
		dial_indicator.color = Color(0, 0.8, 1, 1)
	
	if en_zona != "":
		if en_zona != zona_anterior:
			tiempo_estable = 0.0
		tiempo_estable += delta
		
		var progreso = tiempo_estable / tiempo_requerido
		dial_indicator.size.y = 20 + (20 * progreso)
		
		if tiempo_estable >= tiempo_requerido:
			_estabilizar_senal(en_zona)
	else:
		dial_indicator.size.y = 20

func _estabilizar_senal(zona: String):
	puzzle_completado = true
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
	await get_tree().create_timer(2.0).timeout
	_go_to_scene(SCENE_NEXT)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_radio_room.dialogue"
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
