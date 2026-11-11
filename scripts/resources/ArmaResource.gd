class_name ArmaResource extends Resource

@export_group("sprite y area2d")
## sprite del arma
@export var _sprite: AtlasTexture
## offset que se le da al container para que la mano este en el mango/pivote
@export var _pos_mano: Vector2
## el area de colision
@export var _area_polygon_array: PackedVector2Array

@export_group("data")
## nombre del arma
@export var _nombre: String
## daño del arma
@export var _dmg: int
## si es de 2 manos o no
@export var _es_de_dos_manos: bool

@export_group("Animaciones de ataque")
## animaciones de los ataques
@export var _animaciones: Array[AnimacionAtaqueResource]

## retorna el sprite del arma
func get_sprite() -> AtlasTexture:
	return _sprite

## retorna la posicion del mango del arma respecto al centro
func get_pos_mano() -> Vector2:
	return _pos_mano

## retorna las coordenadas del hitbox del area2d
func get_hitbox_area() -> PackedVector2Array:
	return _area_polygon_array

## retorna el nombre del arma
func get_nombre() -> String:
	return _nombre

## retorna el daño que hace el arma
func get_dmg() -> int:
	return _dmg

## retorna si el arma es de 2 manos
func es_de_dos_manos() -> bool:
	return _es_de_dos_manos

## retorna la lista de animaciones
func get_animaciones() -> Array[AnimacionAtaqueResource]:
	return _animaciones
