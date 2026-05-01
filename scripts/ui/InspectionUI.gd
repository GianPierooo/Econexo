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

func mostrar(fragment_data):
	# Soporta tanto Dictionary como FragmentData (Resource)
	if fragment_data is Dictionary:
		titulo.text = fragment_data.get("nombre", "")
		texto.text = fragment_data.get("descripcion", "")
		var img_path = fragment_data.get("imagen", "")
		if img_path != "":
			imagen.texture = load(img_path)
		else:
			imagen.texture = null
	else:
		# Es un FragmentData Resource
		titulo.text = fragment_data.nombre
		texto.text = fragment_data.texto_inspeccion
		imagen.texture = fragment_data.imagen

	visible = true
	get_tree().paused = true

func _cerrar():
	visible = false
	get_tree().paused = false
