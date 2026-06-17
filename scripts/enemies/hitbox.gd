extends Area2D

var health = 10
var amount = 1

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(_area): #ATAQUES DE LYRA A MOUNSTRUOS UTILIZAN LAYER 5!!!!!
	health -= amount
	print("Dummy recibió ", amount, " de daño")
	print("Vida restante:", health)

	if health <= 0:
		die()

func die():
	print("Dummy murió")
	queue_free()
