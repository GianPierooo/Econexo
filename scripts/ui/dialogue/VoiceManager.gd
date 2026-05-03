# VoiceManager.gd
extends Node

var voces: Array = []
var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	_cargar_voces()

func _cargar_voces():
	# Lista explícita de archivos — funciona en navegador y escritorio
	var rutas = [
		"res://assets/sounds/nexo/voz/Econexo_Voz1.wav",
		"res://assets/sounds/nexo/voz/Econexo_Voz2.wav",
		"res://assets/sounds/nexo/voz/Econexo_Voz3.wav",
		"res://assets/sounds/nexo/voz/Econexo_Voz4.wav",
		"res://assets/sounds/nexo/voz/Econexo_Voz5.wav",
		"res://assets/sounds/nexo/voz/Econexo_Voz6.wav",
        "res://assets/sounds/nexo/voz/Econexo_Voz7.wav"
	]
	
	for ruta in rutas:
		var audio = load(ruta)
		if audio:
			voces.append(audio)
	
	print("Voces cargadas: ", voces.size())

func play_voz():
	if voces.is_empty():
		return
	if player.playing:
		player.stop()
	player.stream = voces[randi() % voces.size()]
	player.play()
