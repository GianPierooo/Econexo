extends Node2D

@onready var piezas = $Piezas
@onready var pared_vacia = $ParedVacia

const SCENE_NEXT = "res://scenes/levels/level_01/lvl1_container_puzzle.tscn"

var piezas_colocadas: int = 0
var total_piezas: int = 4
var puzzle_completado: bool = false
var dialogue_playing: bool = false
var poster_completo: Node

func _ready() -> void:
	poster_completo = find_child("PosterCompleto")
	if poster_completo == null:
		push_error("❌ PosterCompleto no encontrado")
		return
	poster_completo.visible = false
	
	for pieza in piezas.get_children():
		pieza.input_event.connect(_on_pieza_clicked.bind(pieza))
	
	await get_tree().process_frame
	await _play_dialogue("start")

func _on_pieza_clicked(_viewport, event, _shape_idx, pieza: Node):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if puzzle_completado or dialogue_playing:
				return
			_colocar_pieza(pieza)

func _colocar_pieza(pieza: Node):
	pieza.input_pickable = false
	pieza.visible = false
	piezas_colocadas += 1
	print("🧩 Pieza colocada: ", piezas_colocadas, "/", total_piezas)
	await _play_dialogue("pieza_colocada")
	if piezas_colocadas >= total_piezas:
		await _completar_puzzle()

func _completar_puzzle():
	puzzle_completado = true
	poster_completo.visible = true
	await _play_dialogue("poster_completo")
	await _play_dialogue("leer_poster")
	await _play_dialogue("reaccion")
	await _play_dialogue("cierre")
	FragmentManager.add_fragment("F4_poster")
	await get_tree().create_timer(2.0).timeout
	_go_to_scene(SCENE_NEXT)

func _play_dialogue(title: String) -> void:
	var path = "res://data/dialogues/level_01/lvl1_alley.dialogue"
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
