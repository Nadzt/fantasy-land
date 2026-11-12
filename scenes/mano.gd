class_name Mano extends Marker2D

@export var arma: ArmaMelee

func set_arma(arma: ArmaMelee) -> void:
	arma = arma

func usar() -> void:
	arma.usar()
