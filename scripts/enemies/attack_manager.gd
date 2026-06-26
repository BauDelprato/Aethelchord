extends Node2D

#Collision LAYER en la Layer 6 
@onready var Attackbox = $"../Attackbox"
@onready var AttackCollision = $"../Attackbox/CollisionShape2D"
@onready var timer = $Timer

func _ready():
	AttackCollision.disabled = true
	Attackbox.monitoring = false
	timer.wait_time = 2.0
	timer.start()

func _on_timer_timeout():
	attack()

func attack():
	print("¡CONTACTO ENEMIGO!")
	AttackCollision.disabled = false
	Attackbox.monitoring = true
	await get_tree().create_timer(0.5).timeout

	AttackCollision.disabled = true
	Attackbox.monitoring = false
