extends Node2D

@onready var boton_cargar = $VBoxContainer/Cargar

#func _ready() -> void:
	#if #Si hay partida guardada:
	#	boton_cargar.visible #Mostrar el boton cargar

func _on_nueva_partida_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/mundo.tscn")


func _on_cargar_button_down() -> void:
	pass #Aca deberia cargar del GameManager

func _on_creditos_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")
	

func _on_salir_button_down() -> void:
	get_tree().quit()
