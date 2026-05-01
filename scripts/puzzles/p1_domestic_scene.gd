# p1_domestic_scene.gd
extends Node2D

@onready var chair = $Hotspots/ChairSpot
@onready var plate = $Hotspots/PlateSpot
@onready var radio = $Hotspots/RadioSpot
@onready var frame = $Hotspots/FrameSpot
@onready var family_fragment = $Fragments/FamilyPhotoFragment

var state = {
	"chair": false,
	"plate": false,
	"radio": false,
	"frame": false
}

func _ready():
	family_fragment.visible = false
	
	# Cada objeto avisa cuando encajó en su target
	chair.clicked.connect(_on_chair_correct)
	plate.clicked.connect(_on_plate_correct)
	radio.clicked.connect(_on_radio_correct)
	frame.clicked.connect(_on_frame_correct)
	
	family_fragment.clicked.connect(_on_family_fragment_clicked)

func _on_chair_correct():
	state["chair"] = true
	print("Silla en su lugar ✅")
	check_puzzle()

func _on_plate_correct():
	state["plate"] = true
	print("Plato en su lugar ✅")
	check_puzzle()

func _on_radio_correct():
	state["radio"] = true
	print("Radio en su lugar ✅")
	check_puzzle()

func _on_frame_correct():
	state["frame"] = true
	print("Marco en su lugar ✅")
	check_puzzle()

func check_puzzle():
	if state["chair"] and state["plate"] and state["radio"] and state["frame"]:
		print("🎉 Puzzle completado")
		family_fragment.visible = true
		# Cuando tengas FragmentManager listo:
		# FragmentManager.add_fragment("F1_foto_familiar")

func _on_family_fragment_clicked():
	print("Mostrar inspección F1")
	# Cuando tengas InspectionUI listo:
	# InspectionUI.show_fragment("F1_foto_familiar")
