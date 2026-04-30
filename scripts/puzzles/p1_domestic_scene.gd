extends Node2D

@onready var chair = $Hotspots/ChairSpot
@onready var plate = $Hotspots/PlateSpot
@onready var radio = $Hotspots/RadioSpot
@onready var frame = $Hotspots/FrameSpot

@onready var chair_target = $Markers/ChairTarget
@onready var plate_target = $Markers/PlateTarget
@onready var radio_target = $Markers/RadioTarget
@onready var frame_target = $Markers/FrameTarget

@onready var family_fragment = $Fragments/FamilyPhotoFragment


var state = {
	"chair": false,
	"plate": false,
	"radio": false,
	"frame": false
}

func _ready() -> void:
	family_fragment.visible = false
	chair.clicked.connect(_on_chair_clicked)
	plate.clicked.connect(_on_plate_clicked)
	radio.clicked.connect(_on_radio_clicked)
	frame.clicked.connect(_on_frame_clicked)
	family_fragment.clicked.connect(_on_family_fragment_clicked)



func _on_chair_clicked() -> void:
	chair.global_position = chair_target.global_position
	state["chair"] = true
	check_puzzle()

func _on_plate_clicked() -> void:
	plate.global_position = plate_target.global_position
	state["plate"] = true
	check_puzzle()

func _on_radio_clicked() -> void:
	radio.global_position = radio_target.global_position
	state["radio"] = true
	check_puzzle()

func _on_frame_clicked() -> void:
	frame.global_position = frame_target.global_position
	state["frame"] = true
	check_puzzle()

func check_puzzle() -> void:
	if state["chair"] and state["plate"] and state["radio"] and state["frame"]:
		family_fragment.visible = true

func _on_family_fragment_clicked() -> void:
	print("Mostrar F1")
