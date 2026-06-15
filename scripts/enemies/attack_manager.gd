extends Node2D
#LAYER 6 PARA ATAQUES ENEMIGOS A LYRA!!!
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
	print("ATAQUE ENEMMIGO!!!!323")
	AttackCollision.disabled = false
	Attackbox.monitoring = true

	await get_tree().create_timer(0.5).timeout

	AttackCollision.disabled = true
	Attackbox.monitoring = false
