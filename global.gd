extends Node

signal score_cambiado(nuevo_score)

var score: int = 0

func sumar_puntos(cantidad: int) -> void:
	score += cantidad
	score_cambiado.emit(score)

func reiniciar_score() -> void:
	score = 0
	score_cambiado.emit(score)
