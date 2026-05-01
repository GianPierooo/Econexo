# p1_domestic_scene.gd
extends Node2D

@onready var chair = $Hotspots/ChairSpot
@onready var plate = $Hotspots/PlateSpot
@onready var radio = $Hotspots/RadioSpot
@onready var frame = $Hotspots/FrameSpot
@onready var family_fragment = $Fragments/FamilyPhotoFragment

# Referencia al InspectionUI
@onready var inspection_ui = get_tree().get_root().find_child("InspectionUI", true, false)

var state = {
	"chair": false,
	"plate": false,
	"radio": false,
	"frame": false
}

# Datos del fragmento F1
var f1_data = {
	"nombre": "Foto Familiar",
	"descripcion": "Una fotografía de una familia aparentemente normal.\nHay algo raro… no termino de entender qué.\nAlgo no coincide… pero no sé qué es.",
	"imagen": ""  # cuando tengas la imagen: "res://assets/fragmentos/f1_foto.png"
}

func _ready():
	family_fragment.visible = false
	family_fragment.set_process(false)  # no interactuable al inicio
	
	chair.clicked.connect(_on_chair_correct)
	plate.clicked.connect(_on_plate_correct)
	radio.clicked.connect(_on_radio_correct)
	frame.clicked.connect(_on_frame_correct)
	family_fragment.clicked.connect(_on_family_fragment_clicked)

func _on_chair_correct():
	state["chair"] = true
	check_puzzle()

func _on_plate_correct():
	state["plate"] = true
	check_puzzle()

func _on_radio_correct():
	state["radio"] = true
	check_puzzle()

func _on_frame_correct():
	state["frame"] = true
	check_puzzle()

func check_puzzle():
	if state["chair"] and state["plate"] and state["radio"] and state["frame"]:
		print("🎉 Puzzle completado")
		_activar_fragmento_F1()

func _activar_fragmento_F1():
	# Marco se vuelve visible e interactuable
	family_fragment.visible = true
	family_fragment.set_process(true)
	
	# Cuando tengas FragmentManager:
	# FragmentManager.add_fragment("F1_foto_familiar")

func _on_family_fragment_clicked():
	if inspection_ui:
		inspection_ui.mostrar(f1_data)
	else:
		print("ERROR: InspectionUI no encontrado")
