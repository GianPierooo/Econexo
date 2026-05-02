# VoiceManager.gd
extends Node

var voces: Array = []
@onready var player = AudioStreamPlayer.new()

func _ready():
	add_child(player)
	_cargar_voces()

func _cargar_voces():
	# Carga todos los archivos de la carpeta
	var dir = DirAccess.open("res://assets/sounds/nexo/voz/")
	if dir:
		dir.list_dir_begin()
		var archivo = dir.get_next()
		while archivo != "":
			if archivo.ends_with(".wav") or archivo.ends_with(".ogg") or archivo.ends_with(".mp3"):
				voces.append(load("res://assets/sounds/nexo/voz/" + archivo))
			archivo = dir.get_next()
	print("Voces cargadas: ", voces.size())

func play_voz():
	if voces.is_empty():
		return
	if player.playing:
		player.stop()
	player.stream = voces[randi() % voces.size()]
	player.play()
