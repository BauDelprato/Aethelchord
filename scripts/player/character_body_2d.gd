extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var lyra_health = $HealthManager
@onready var lyra_ability = $AbilityManager

var is_attacking = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Input.get_axis("ui_left", "ui_right")

	if Input.is_action_just_pressed("attack") and !is_attacking:
		$AbilityManager.attack()

	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if !is_attacking:
		update_animation(direction)

	move_and_slide()

func update_animation(direction):

	if not is_on_floor():
		animation.play("lyra_idle") # cambiar por salto después
	elif direction != 0:
		animation.play("lyra_walk")
	else:
		animation.play("lyra_idle")
