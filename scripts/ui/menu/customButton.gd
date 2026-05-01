extends Button
class_name customButton
@onready var Click: AudioStreamPlayer2D = $Click
@onready var OnHover: AudioStreamPlayer2D = $OnHover

func _on_pressed() -> void:
	Click.play()


func _on_mouse_entered() -> void:
	OnHover.play()
