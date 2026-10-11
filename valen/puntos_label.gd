extends Label

func _ready():
	GameManager.sumar_puntos.connect(_on_score_changed)
	
func _on_score_changed():
	text = str(GameManager.score)
