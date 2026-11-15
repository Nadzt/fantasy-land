class_name Mano extends Marker2D

@export var arma: ArmaMelee

func set_arma(nueva_arma: ArmaMelee) -> void:
	arma = nueva_arma

func usar() -> void:
	arma.usar()
