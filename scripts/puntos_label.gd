extends Label

func _ready():
	GameManager.puntos_cambiados.connect(_on_score_changed)
	
func _on_score_changed():
	text = str(GameManager.puntos)
