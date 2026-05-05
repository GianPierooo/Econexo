# FragmentManager.gd
extends Node
signal fragmento_agregado(fragmento)
var inventario: Array = []
var catalogo: Dictionary = {}
var energia_activa: bool = false
func _ready():
	_registrar_fragmentos()
func _registrar_fragmentos():
	catalogo["F1_foto_familiar"] = {
		"id": "F1_foto_familiar",
		"nombre": "Foto Familiar",
		"tipo": "FOTOGRAFÍA",
		"descripcion": "ANÁLISIS DE IMAGEN — NX-0\n\nRostros detectados: 3. Adulto masculino, adulto femenino, menor masculino.\n\nAnomalia genética: pigmentación capilar del menor no coincide con ninguno de los progenitores. Probabilidad de vínculo biológico: 12%.\n\nFecha estimada de la fotografía: 1978. El uniforme corresponde al Ejército Argentino, período 1976-1983.\n\nRegistros de adopciones irregulares en ese período: clasificados. Acceso denegado.\n\nConclusión del sistema: este fragmento requiere validación cruzada con otros datos.",
		"imagen": "res://assets/art/level_01/fragments/f1_family_photo.png"
	}
	catalogo["F2_diario"] = {
		"id": "F2_diario",
		"nombre": "Diario Oculto",
		"tipo": "DOCUMENTO",
		"descripcion": "ANÁLISIS DOCUMENTAL — NX-0\n\nElementos detectados: 3 objetos distintos almacenados juntos de forma deliberada.\n\nFotografía 1: bebé de aproximadamente 8 meses sostenido por mujer adulta desconocida. Expresión: angustia.\n\nFotografía 2: retrato de la misma mujer. Sin identificación visible.\n\nRecorte de diario: menciona listas de personas desaparecidas. Fecha: 1977.\n\nPatrón de ocultamiento: los tres objetos fueron doblados y colocados bajo el forro del cajón. Comportamiento consistente con preservación de evidencia bajo coerción.\n\nAlguien sabía. Y guardó la prueba.",
		"imagen": "res://assets/art/level_01/fragments/f2_diario.png"
	}
	catalogo["F3_lista"] = {
		"id": "F3_lista",
		"nombre": "Lista del Edificio",
		"tipo": "DOCUMENTO",
		"descripcion": "ANÁLISIS DOCUMENTAL — NX-0\n\nTotal de residentes registrados: 34.\nNombres tachados completamente: 9.\nNombres con anotación 'desaparecido': 6.\nNombres marcados en rojo con fecha: 4.\n\nPatrón temporal: las marcas rojas se concentran entre marzo y diciembre de 1977.\n\nEste documento no es oficial. Fue elaborado por el encargado del edificio de forma privada.\n\nHipótesis del sistema: el encargado llevaba registro propio para saber quiénes no iban a volver. Posible colaborador. Posible testigo forzado.\n\nEste fragmento es evidencia directa de conocimiento civil sobre las desapariciones.",
		"imagen": "res://assets/art/level_01/fragments/f3_lista.png"
	}
	catalogo["F4_poster"] = {
		"id": "F4_poster",
		"nombre": "Poster de Videla",
		"tipo": "OBJETO",
		"descripcion": "ANÁLISIS DE OBJETO — NX-0\n\nMaterial: papel offset. Impresión en offset a dos tintas. Producción masiva.\n\nContenido del mensaje: negación oficial de las desapariciones. Firma: Junta Militar, 1978.\n\nEstado: fragmentado en 5 piezas. Encontrado en contenedor de residuos del callejón lateral.\n\nAnálisis del daño: el desgarro es manual, no mecánico. Alguien lo arrancó con fuerza.\n\nHuella de adhesivo en la pared exterior: el cartel estuvo colocado durante al menos 6 meses.\n\nContradicción detectada: el discurso del cartel niega lo que la Lista del Edificio confirma.\n\nAlguien sabía que era mentira. Y lo destruyó.",
		"imagen": "res://assets/art/level_01/fragments/f4_poster.png"
	}
	catalogo["F5_radio"] = {
		"id": "F5_radio",
		"nombre": "Voces de la Radio",
		"tipo": "AUDIO",
		"descripcion": "ANÁLISIS DE SEÑAL — NX-0\n\nFrecuencia principal: transmisión oficial del Estado. Señal estable. Contenido: discurso institucional de control.\n\nFrecuencia secundaria detectada: señal encubierta. Múltiples emisores simultáneos.\n\nVoces identificadas: no menos de 40 fuentes distintas.\n\nContenido decodificado: nombres propios, búsquedas de personas, testimonios fragmentados.\n\nFrase recurrente: 'Nunca más'. 'Memoria, verdad y justicia'.\n\nAnálisis temporal: estas transmisiones son anteriores a cualquier reconocimiento oficial.\n\nConclusión: la verdad existía en paralelo al discurso oficial. Solo había que saber escuchar.",
		"imagen": "res://assets/art/level_01/fragments/f5_radio.png"
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
