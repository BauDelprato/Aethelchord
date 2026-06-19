extends Area2D

var health = 3
var amount = 1
var damaged = false

signal defeated


func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(_area): #ATAQUES DE LYRA A MOUNSTRUOS UTILIZAN LAYER 5!!!!!
	health -= amount
	damaged = true
	print("Do recibió ", amount, " de daño")
	print("Vida restante:", health)

	if health <= 0:
		die()

func die():
	
	defeated.emit()
	queue_free()
