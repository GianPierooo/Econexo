# InspectionUI.gd
extends CanvasLayer

@onready var panel = $Panel
@onready var imagen = $Panel/TextureRect
@onready var titulo = $Panel/Label
@onready var texto = $Panel/RichTextLabel
@onready var boton_cerrar = $Panel/Button

func _ready():
	visible = false
	boton_cerrar.process_mode = Node.PROCESS_MODE_ALWAYS
	boton_cerrar.pressed.connect(_cerrar)
	boton_cerrar.text = "✕ Cerrar"
	
	# Centrar el panel en pantalla
	panel.size = Vector2(900, 600)
	panel.position = Vector2((1920 - 900) / 2, (1080 - 600) / 2)
	
	# Estilo del panel
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.07, 0.10, 0.97)
	style.border_color = Color(0.0, 0.78, 1.0, 0.8)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(20)
	panel.add_theme_stylebox_override("panel", style)
	
	# Título
	titulo.add_theme_color_override("font_color", Color(0.0, 0.78, 1.0))
	titulo.add_theme_font_size_override("font_size", 18)
	titulo.anchor_left = 0.0
	titulo.anchor_right = 1.0
	titulo.anchor_top = 0.0
	titulo.anchor_bottom = 0.0
	titulo.offset_top = 10
	titulo.offset_bottom = 40
	
	# Imagen ocupa lado izquierdo
	imagen.anchor_left = 0.0
	imagen.anchor_right = 0.55
	imagen.anchor_top = 0.1
	imagen.anchor_bottom = 0.85
	imagen.offset_left = 10
	imagen.offset_right = -10
	imagen.offset_top = 10
	imagen.offset_bottom = -10
	imagen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	imagen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Texto lado derecho
	texto.anchor_left = 0.55
	texto.anchor_right = 1.0
	texto.anchor_top = 0.1
	texto.anchor_bottom = 0.85
	texto.offset_left = 10
	texto.offset_right = -10
	texto.offset_top = 10
	texto.offset_bottom = -10
	texto.add_theme_color_override("default_color", Color(0.8, 0.85, 0.9))
	texto.add_theme_font_size_override("normal_font_size", 13)
	
	# Botón cerrar abajo centrado
	boton_cerrar.anchor_left = 0.35
	boton_cerrar.anchor_right = 0.65
	boton_cerrar.anchor_top = 0.88
	boton_cerrar.anchor_bottom = 1.0
	boton_cerrar.offset_top = 5
	boton_cerrar.offset_bottom = -10

func mostrar(fragment_data):
	if fragment_data is Dictionary:
		titulo.text = fragment_data.get("nombre", "")
		texto.text = fragment_data.get("descripcion", "")
		var img_path = fragment_data.get("imagen", "")
		if img_path != "":
			imagen.texture = load(img_path)
		else:
			imagen.texture = null
	else:
		titulo.text = fragment_data.nombre
		texto.text = fragment_data.texto_inspeccion
		imagen.texture = fragment_data.imagen
	visible = true
	get_tree().paused = true

func _cerrar():
	visible = false
	get_tree().paused = false
