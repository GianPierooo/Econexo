# p1_domestic_scene.gd
extends Node2D

@onready var chair = $Hotspots/ChairSpot
@onready var plate = $Hotspots/PlateSpot
@onready var radio = $Hotspots/RadioSpot
@onready var frame = $Hotspots/FrameSpot
@onready var family_fragment = $Fragments/FamilyPhotoFragment
@onready var inspection_ui = $InspectionUI
@onready var context_menu = $ContextMenu
@onready var inventory_ui = $InventoryUI

var state = {
	"chair": false,
	"plate": false,
	"radio": false,
	"frame": false
}

var f1_data = {
	"nombre": "Foto Familiar",
	"descripcion": "Una fotografía de una familia aparentemente normal.\nHay algo raro… no termino de entender qué.\nAlgo no coincide… pero no sé qué es.",
	"imagen": ""
}

func _ready():
	family_fragment.visible = false
	
	chair.clicked.connect(_on_chair_correct)
	plate.clicked.connect(_on_plate_correct)
	radio.clicked.connect(_on_radio_correct)
	frame.clicked.connect(_on_frame_correct)
	family_fragment.clicked.connect(_on_family_fragment_clicked)
	
	# Conectar menú contextual
	context_menu.on_inspect.connect(_on_inspect)
	context_menu.on_scan.connect(_on_scan)

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
	family_fragment.visible = true
	
	# Agregar F1 al inventario
	FragmentManager.add_fragment("F1_foto_familiar")
	
	# Conectar slots del inventario con el menú contextual
	for slot in inventory_ui.slots_container.get_children():
		if not slot.is_empty:
			if not slot.slot_clicked.is_connected(_on_slot_clicked):
				slot.slot_clicked.connect(_on_slot_clicked)

func _on_family_fragment_clicked():
	inspection_ui.mostrar(f1_data)

func _on_slot_clicked(fragment_data):
	var mouse_pos = get_viewport().get_mouse_position()
	context_menu.show_menu(fragment_data, mouse_pos)

func _on_inspect(fragment_data):
	inspection_ui.mostrar(fragment_data)

func _on_scan(fragment_data):
	print("Escaneando: ", fragment_data.id)
