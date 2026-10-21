class_name ArmaMelee extends Node2D

@export var debug: bool = true
@export var res: ArmaResource
@export var nombre: String
@export var dmg: int
@export var es_de_dos_manos: bool

@export_group("componentes")
@export var sprite: Sprite2D
## el pivote que se rota para las animaciones
@export var pivote: Node2D
## el container que se mueve para que el pivote se alinie con la mano del arma
@export var container: Node2D
@export var hitbox: CollisionPolygon2D
@export_subgroup("timers")
@export var cooldown_timer: Timer
@export var esperando_timer: Timer

@export_group("stats de animacion")
## tipo de ataque, puede ser en arco (slash) o estocada (stabby stab)
@export var tipo_ataque: ArmaResource.tipo_ataque
## arco de ataque para un ataque de tipo slash (en radianes)
@export var arco_de_ataque: float
## la velocidad en la que se mueve el arma cuando ataca
@export var speed: float
## el tiempo de espera que esta en la posicion final del ataque antes de volver
@export var wait_time: float
## la velocidad en la que vuelve despues de atacar
@export var speed_return: float
## el tiempo que tarda en habilitarse el proximo ataque
@export var cooldown: float

@export_group("estado de ataque")
## estados en los que se puede encontrar un ataque
enum estado {
	lista,
	atacando,
	esperando,
	volviendo,
	en_cooldown
}

var estado_actual: estado = estado.lista
var angulo_acumulado: float = 0.0
#
var traslado_acumulado: float = 0.0
var progreso: float = 0.0
var tiempo_de_ataque: float = .3
var curva_ease: float = 4.0

## ejecuta una funcion si esta modo debug activado
func print_dev(callback: Callable) -> void:
	if debug:
		callback.call()

## me muestra las coordenadas de hitbox que cree para crear recursos mas rapido
func print_coords_hitbox() -> void:
	# ver poligones
	var collision_polygon_2d: CollisionPolygon2D = $Pivote/Container/Area2D/CollisionPolygon2D
	for x in collision_polygon_2d.polygon:
		print(x)

## TODO: Pasar al jugador:
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("usar_mano_izq") and estado_actual == estado.lista:
		print("usando mano izquierda")
		usar()
	
	if Input.is_action_just_pressed("usar_mano_der") and estado_actual == estado.lista:
		print("usando mano derecha")
		usar()

#
func _ready() -> void:
	print_dev(print_coords_hitbox)
		
	_cargar_sprite_y_alinear()
	_cargar_info_general()
	_cargar_stats_de_animacion()

#
func _physics_process(delta: float) -> void:
	# animaciones de ataque
	match tipo_ataque:
		ArmaResource.tipo_ataque.arco:
			ataque_en_arco(delta)
		
		ArmaResource.tipo_ataque.estocada:
			ataque_en_estocada(delta)

#region inicializacion
## carga el sprite, posiciona el origen en el mango y carga el hitbox
func _cargar_sprite_y_alinear() -> void:
	sprite.texture = res.get_sprite()
	container.position = res.get_pos_mano()
	hitbox.polygon = res.get_hitbox_area()

## carga la info general del arma
func _cargar_info_general() -> void:
	nombre = res.get_nombre()
	dmg = res.get_dmg()
	es_de_dos_manos = res.es_de_dos_manos()

## carga los stats que uso para las animaciones
func _cargar_stats_de_animacion() -> void:
	tipo_ataque = res.get_tipo_de_ataque()
	arco_de_ataque = res.get_atk_arc()
	speed = res.get_speed()
	speed_return = res._speed_return
	wait_time = res.get_wait_t()
	cooldown = res.get_cd()

#endregion

## empieza un ataque
func usar() -> void:
	print("%s: usando arma" % nombre)
	empezar_ataque()

#region ciclo de vida de un ataque
## empieza el ciclo de vida de un ataque
func empezar_ataque() -> void:
	angulo_acumulado = 0.0
	hitbox.disabled = false
	estado_actual = estado.atacando

## animacion de ataque de un arma tipo arco, ida y vuelta
func ataque_en_arco(delta: float) -> void:
	# animo la ida si tiene esta atacando
	if estado_actual == estado.atacando:
		animar_en_arco_ida(delta)
	
	# animo la vuelta si tiene que volver
	if estado_actual == estado.volviendo:
		animar_en_arco_vuelta(delta)

func ataque_en_estocada(delta: float) -> void:
	# animo la ida si tiene esta atacando
	if estado_actual == estado.atacando:
		animar_estocada_ida(delta)
	
	# animo la vuelta si tiene que volver
	#if estado_actual == estado.volviendo:
		#animar_en_arco_vuelta(delta)


## empieza el timer entre que cae el arma y empieza a volver
func _start_wait_time(time: float) -> void:
	esperando_timer.wait_time = time
	esperando_timer.start()

## empieza el timer entre que termino una animacion de ataque y puede volver a atacar
func _start_cd(time: float) -> void:
	estado_actual = estado.en_cooldown
	cooldown_timer.wait_time = time
	cooldown_timer.start()

## cambia el estado de ataque y deshabilita el hitbox
func terminar_ataque() -> void:
	estado_actual = estado.esperando
	hitbox.disabled = true

#endregion

#region animaciones de arco

## anima la ida del ataque tipo arco, termina el ataque si se cumple con el "arco de ataque"
func animar_en_arco_ida(delta: float) -> void:
	# calculo el paso de la rotacion que tiene que hacer sobre el pivote
	var rotacion = speed * delta
	
	# agrego la rotacion al angulo acumulado
	angulo_acumulado += rotacion
	if angulo_acumulado >= arco_de_ataque:
		# si el arco acumulado es mayor a lo que tiene que ser recorto lo que sobra
		# termina el ataque y empieza el timer de espera en esa posicion
		rotacion -= angulo_acumulado - arco_de_ataque
		terminar_ataque()
		_start_wait_time(wait_time)
	
	# aplico la rotacion
	pivote.rotate(rotacion)

## anima la vuelta del ataque tipo arco
func animar_en_arco_vuelta(delta: float) -> void:
	var rotacion = - speed_return * delta
	
	# casi lo mismo que la animacion de ida, pero empieza el cd entre ataques al volver
	if pivote.rotation + rotacion <= 0.0:
		pivote.rotation = 0.0
		rotacion = 0.0
		_start_cd(cooldown)
	
	pivote.rotate(rotacion)

#endregion

## cambia el estado del arma para que empiece a volver
func _on_esperando_timer_timeout() -> void:
	print("%s: termino espera" % nombre)
	estado_actual = estado.volviendo

## cambia el estado del arma para que este lista para un nuevo ataque
func _on_cooldown_timer_timeout() -> void:
	print("%s: termino cd" % nombre)
	estado_actual = estado.lista

## Hitbox
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("%s le pego a un body: %s" % [nombre, body.name])


#region animaciones de estocada

## anima la ida del ataque tipo estocada, termina el ataque al llegar al "rango estocada"
func animar_estocada_ida(delta: float) -> void:
	print(res._largo_estocada / speed)
	# calculo el total del progreso en tiempo
	progreso += delta / tiempo_de_ataque
	progreso = min(progreso, 1.0)
	
	# calculo el porcentaje sobre el total que debe recorrer con la funcion ease(,)
	# si el 2do parametro es mayor a 1 es ease-in https://byteatatime.dev/posts/easings/
	var t_suave = ease(progreso, curva_ease)
	
	# calculo la nueva posicion
	var nueva_pos_x = t_suave * res._largo_estocada
	
	# si es el final termino el ataque
	if progreso >= 1.0:
		# termina el ataque y empieza el timer de espera
		terminar_ataque()
		_start_wait_time(wait_time)
	
	pivote.position.x = nueva_pos_x

#endregion
