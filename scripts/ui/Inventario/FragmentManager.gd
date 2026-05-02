# FragmentManager.gd
extends Node

signal fragmento_agregado(fragmento)

var inventario: Array = []
var catalogo: Dictionary = {}

func _ready():
	_registrar_fragmentos()

func _registrar_fragmentos():
	catalogo["F1_foto_familiar"] = {
		"id": "F1_foto_familiar",
		"nombre": "Foto Familiar",
		"tipo": "FOTOGRAFÍA",
		"descripcion": "Una fotografía de una familia aparentemente normal.\nHay algo raro… no termino de entender qué.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}
	catalogo["F2_diario"] = {
		"id": "F2_diario",
		"nombre": "Diario Oculto",
		"tipo": "DOCUMENTO",
		"descripcion": "Habla de desapariciones. Las imágenes no coinciden entre sí.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}
	catalogo["F3_lista"] = {
		"id": "F3_lista",
		"nombre": "Lista del Edificio",
		"tipo": "DOCUMENTO",
		"descripcion": "Una lista de residentes. Algunos nombres están tachados... otros marcados con rojo.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}
	catalogo["F4_poster"] = {
		"id": "F4_poster",
		"nombre": "Poster de Videla",
		"tipo": "OBJETO",
		"descripcion": "Propaganda oficial. Alguien lo arrancó y lo tiró al contenedor.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}
	catalogo["F5_radio"] = {
		"id": "F5_radio",
		"nombre": "Voces de la Radio",
		"tipo": "AUDIO",
		"descripcion": "Detrás del discurso oficial... hay muchas voces. Nombres. Consignas.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}

func add_fragment(id: String):
	if not catalogo.has(id):
		print("ERROR: Fragmento no existe: ", id)
		return
	for f in inventario:
		if f["id"] == id:
			print("Ya tienes: ", id)
			return
	var fragmento = catalogo[id]
	inventario.append(fragmento)
	emit_signal("fragmento_agregado", fragmento)
	print("✅ Fragmento agregado: ", fragmento["nombre"])

func tiene_fragmento(id: String) -> bool:
	for f in inventario:
		if f["id"] == id:
			return true
	return false
