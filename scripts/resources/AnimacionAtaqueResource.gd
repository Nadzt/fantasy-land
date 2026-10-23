class_name AnimacionAtaqueResource extends Resource

## el tiempo de cooldown de un arma, el tiempo entre que termina volviendo y se pone lista
@export var _cooldown: float

@export_group("Animacion - Anticipacion", "_ant")
## determina si la animacion hace una traslacion o no
@export var _ant_tiene_rotacion: bool
## determina si la animacion hace una traslacion o no
@export var _ant_tiene_traslacion: bool
## el tiempo entre la animacion de anticipacion y atacando
@export var _ant_tiempo_de_espera: float

@export_subgroup("Arco", "_ant_r")
## el tiempo total que cura la traslacion
@export var _ant_r_duracion: float
## la curva de animacion de esa traslacion
@export var _ant_r_curva_ease: float
## la distancia objetivo que se quiere trasladar
@export var _ant_r_distancia: float

@export_subgroup("Traslacion", "_ant_t")
## el tiempo total que cura la traslacion
@export var _ant_t_duracion: float
## la curva de animacion de esa traslacion
@export var _ant_t_curva_ease: float
## la distancia objetivo que se quiere trasladar
@export var _ant_t_distancia: float

@export_group("Animacion - Atacando", "_atk")
## determina si la animacion hace una traslacion o no
@export var _atk_tiene_rotacion: bool
## determina si la animacion hace una traslacion o no
@export var _atk_tiene_traslacion: bool
## el tiempo entre la animacion de atacando y la animacion de volver
@export var _atk_tiempo_de_espera: float

@export_subgroup("Arco", "_atk_r")
## el tiempo total que cura la traslacion
@export var _atk_r_duracion: float
## la curva de animacion de esa traslacion
@export var _atk_r_curva_ease: float
## la distancia objetivo que se quiere trasladar
@export var _atk_r_distancia: float

@export_subgroup("Traslacion", "_atk_t")
## el tiempo total que cura la traslacion
@export var _atk_t_duracion: float
## la curva de animacion de esa traslacion
@export var _atk_t_curva_ease: float
## la distancia objetivo que se quiere trasladar
@export var _atk_t_distancia: float

@export_group("Animacion - Volviendo", "_vol")
@export_subgroup("Arco", "_vol_r")
## el tiempo total que cura la traslacion
@export var _vol_r_duracion: float
## la curva de animacion de esa traslacion
@export var _vol_r_curva_ease: float
## la distancia objetivo que se quiere trasladar
var _vol_r_distancia: float

@export_subgroup("Traslacion", "_vol_t")
## el tiempo total que cura la traslacion
@export var _vol_t_duracion: float
## la curva de animacion de esa traslacion
@export var _vol_t_curva_ease: float
## la distancia objetivo que se quiere trasladar
var _vol_t_distancia: float

## retorna el tiempo de cooldown de un arma
func get_cooldown() -> float:
	return _cooldown



## Anticipacion Anticipacion Anticipacion Anticipacion

## retorna si la anticipacion aplica rotacion
func get_ant_tiene_rotacion() -> bool:
	return _ant_tiene_rotacion

## retorna si la anticipacion aplica traslacion
func get_ant_tiene_traslacion() -> bool:
	return _ant_tiene_traslacion

## retorna el tiempo de espera que ocurre despues de la anticipacion
func get_ant_tiempo_espera() -> float:
	return _ant_tiempo_de_espera

## retorna la duracion de la rotacion de la anticipacion
func get_ant_r_duracion() -> float:
	return _ant_r_duracion

## retorna la curva ease de la rotacion de la anticipacion
func get_ant_r_curva_ease() -> float:
	return _ant_r_curva_ease

## retorna la distancia en radianes de la rotacion de la anticipacion 
func get_ant_r_distancia() -> float:
	if _ant_tiene_rotacion:
		return _ant_r_distancia
	return 0.0

## retorna la duracion de la traslacion de la anticipacion
func get_ant_t_duracion() -> float:
	return _ant_t_duracion

## retorna la curva ease de la traslacion de la anticipacion
func get_ant_t_curva_ease() -> float:
	return _ant_t_curva_ease

## retorna la distancia en px de la traslacion de la anticipacion 
func get_ant_t_distancia() -> float:
	if _ant_tiene_traslacion:
		return _ant_t_distancia * -1
	return 0.0



## Atacando Atacando Atacando Atacando Atacando Atacando

## retorna si la animacion atacando aplica rotacion
func get_atk_tiene_rotacion() -> bool:
	return _atk_tiene_rotacion

## retorna si la animacion atacando aplica traslacion
func get_atk_tiene_traslacion() -> bool:
	return _atk_tiene_traslacion

## retorna el tiempo de espera que ocurre despues de la animacion atacando
func get_atk_tiempo_espera() -> float:
	return _atk_tiempo_de_espera

## retorna la duracion de la rotacion de la animacion atacando
func get_atk_r_duracion() -> float:
	return _atk_r_duracion

## retorna la curva ease de la rotacion de la animacion atacando
func get_atk_r_curva_ease() -> float:
	return _atk_r_curva_ease

## retorna la distancia en radianes de la rotacion de la animacion atacando 
func get_atk_r_distancia() -> float:
	return _atk_r_distancia

## retorna la duracion de la traslacion de la animacion atacando
func get_atk_t_duracion() -> float:
	return _atk_t_duracion

## retorna la curva ease de la traslacion de la animacion atacando
func get_atk_t_curva_ease() -> float:
	return _atk_t_curva_ease

## retorna la distancia en px de la traslacion de la animacion atacando 
func get_atk_t_distancia() -> float:
	return _atk_t_distancia



## Volviendo Volviendo Volviendo Volviendo Volviendo

## retorna la duracion de la rotacion de la animacion volviendo
func get_vol_r_duracion() -> float:
	return _vol_r_duracion

## retorna la curva ease de la rotacion de la animacion volviendo
func get_vol_r_curva_ease() -> float:
	return _vol_r_curva_ease

## retorna la distancia en radianes de la rotacion de la animacion volviendo 
func get_vol_r_distancia() -> float:
	return _vol_r_distancia

## retorna la duracion de la traslacion de la animacion volviendo
func get_vol_t_duracion() -> float:
	return _vol_t_duracion

## retorna la curva ease de la traslacion de la animacion volviendo
func get_vol_t_curva_ease() -> float:
	return _vol_t_curva_ease

## retorna la distancia en px de la traslacion de la animacion volviendo 
func get_vol_t_distancia() -> float:
	return _vol_t_distancia
