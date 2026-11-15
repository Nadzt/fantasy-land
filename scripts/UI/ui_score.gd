extends Control
class_name UIScore

@onready var score_num: Label = $Puntaje

func _ready() -> void:
	
	score_num.text = str(Global.score)

	Global.score_cambiado.connect(actualizar_score)

func actualizar_score(nuevo_score: int) -> void:
	score_num.text = str(nuevo_score)
