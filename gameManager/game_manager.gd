class_name GameManager
extends Node


signal cambiar_puntos

var puntos = 0

func sumar_puntos(points):
	puntos += points
	cambiar_puntos.emit()
