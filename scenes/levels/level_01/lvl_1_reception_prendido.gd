extends Node2D

@onready var libro_fragmento = $LibroFragmento
@onready var nav_arrows = $NavigationArrows
@onready var libro_overlay = $LibroOverlay
@onready var libro_panel = $LibroOverlay/LibroPanel
@onready var background = $Background

var libro_abierto := false

func _ready() -> void:
	nav_arrows.setup(
		"res://scenes/levels/level_01/lvl1_street_02.tscn",
		"res://scenes/levels/level_01/lvl1_stairs_01.tscn"
	)
	
	libro_overlay.visible = false
	libro_panel.pivot_offset = libro_panel.size / 2
	libro_fragmento.clicked.connect(_on_libro_clicked)
	
	if FragmentManager.tiene_fragmento("F3_lista"):
		libro_fragmento.visible = false
		background.texture = load("res://assets/art/level_01/backgrounds/recepcion_con_luz_sinLibro.png")
	else:
		# Ocultar flecha derecha hasta obtener el fragmento
		nav_arrows.flecha_der.visible = false

func _on_libro_clicked() -> void:
	if FragmentManager.tiene_fragmento("F3_lista") or libro_abierto:
		return
	
	libro_abierto = true
	libro_panel.modulate.a = 0.0
	libro_panel.scale = Vector2(0.85, 0.85)
	libro_overlay.visible = true
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(libro_panel, "modulate:a", 1.0, 0.35)
	tween.tween_property(libro_panel, "scale", Vector2(1.0, 1.0), 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
	if not libro_abierto:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_cerrar_libro()

func _cerrar_libro() -> void:
	libro_abierto = false
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(libro_panel, "modulate:a", 0.0, 0.25)
	tween.tween_property(libro_panel, "scale", Vector2(0.85, 0.85), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	libro_overlay.visible = false
	FragmentManager.add_fragment("F3_lista")
	
	var tween2 = create_tween()
	tween2.tween_property(libro_fragmento, "modulate:a", 0.0, 0.4)
	await tween2.finished
	
	libro_fragmento.visible = false
	background.texture = load("res://assets/art/level_01/backgrounds/recepcion_con_luz_sinLibro.png")
	
	# Mostrar flecha derecha ahora que tiene el fragmento
	nav_arrows.flecha_der.visible = true
	
	DialogueManager.show_dialogue_balloon(
		load("res://data/dialogues/level_01/lvl1_receptionPrendido.dialogue"),
		"inicio"
	)
