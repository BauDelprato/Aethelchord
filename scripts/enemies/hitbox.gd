extends Area2D

var health = 5
var amount = 1

@onready var animacion = $"../AnimatedSprite2D"

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(_area): 
	health -= amount
	print("Enemigo recibió daño. Vida restante:", health)

	if health <= 0:
		die()
	else:
		animacion.play("damage")

func die():
	print("Enemigo murió")
	
	get_parent().set_physics_process(false)
	
	set_deferred("monitoring", false)
	
	animacion.play("death")
	await animacion.animation_finished
	
	get_parent().queue_free()
