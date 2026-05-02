extends CanvasLayer

@onready var flecha_izq = $FlechaIzquierda
@onready var flecha_der = $FlechaDerecha

var escena_anterior: String = ""
var escena_siguiente: String = ""

func setup(anterior: String, siguiente: String):
	escena_anterior = anterior
	escena_siguiente = siguiente
	flecha_izq.visible = anterior != ""
	flecha_der.visible = siguiente != ""

func _ready():
	flecha_izq.pressed.connect(_ir_anterior)
	flecha_der.pressed.connect(_ir_siguiente)

func _ir_anterior():
	if escena_anterior != "":
		get_tree().change_scene_to_file(escena_anterior)

func _ir_siguiente():
	if escena_siguiente != "":
		get_tree().change_scene_to_file(escena_siguiente)
