extends Control

@onready var label_score: Label = $LabelScore

func _ready() -> void:
	label_score.text = "Tu score: %s" % GameManager.get_puntos()
	
func _on_volver_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _on_salir_button_down() -> void:
	get_tree().quit()
