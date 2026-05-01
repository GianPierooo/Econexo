# InspectionUI.gd
extends CanvasLayer

@onready var panel = $Panel
@onready var imagen = $Panel/TextureRect
@onready var titulo = $Panel/Label
@onready var texto = $Panel/RichTextLabel
@onready var boton_cerrar = $Panel/Button

func _ready():
	visible = false
	boton_cerrar.pressed.connect(_cerrar)

func mostrar(fragment_data: Dictionary):
	titulo.text = fragment_data["nombre"]
	texto.text = fragment_data["descripcion"]
	
	if fragment_data.has("imagen") and fragment_data["imagen"] != "":
		imagen.texture = load(fragment_data["imagen"])
	
	visible = true
	get_tree().paused = true  # pausa el juego mientras inspeccionas

func _cerrar():
	visible = false
	get_tree().paused = false
