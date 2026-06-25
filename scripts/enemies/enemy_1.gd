extends CharacterBody2D

@export var velocidad: float = 50.0
@export var distancia_maxima: float = 150.0 
@export var fuerza_salto_escalon: float = -300.0 # Ajustá esto para que suba justo el tile

var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")
var posicion_inicial_x: float
var direccion: int = -1 

@onready var sensor_frente = $"CollisionShape2D/RayCast2D"

func _ready():
	posicion_inicial_x = global_position.x

func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta

	# Si choca contra el piso/pared de adelante
	if is_on_wall():
		if not sensor_frente.is_colliding() and is_on_floor():
			velocity.y = fuerza_salto_escalon
		elif sensor_frente.is_colliding():
			direccion *= -1

	# Rango de patrulla
	if global_position.x < posicion_inicial_x - distancia_maxima:
		direccion = 1
	elif global_position.x > posicion_inicial_x + distancia_maxima:
		direccion = -1

	sensor_frente.target_position.x = abs(sensor_frente.target_position.x) * direccion

	velocity.x = velocidad * direccion
	move_and_slide()
	
	# Animación
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
