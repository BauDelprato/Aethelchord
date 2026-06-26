extends Area2D

@export var max_health: int = 3
@onready var current_health: int = max_health 

var amount = 1
var damaged = false

signal health_changed(new_health) 
signal defeated

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(_area): # ATAQUES DE LYRA A MOUNSTRUOS UTILIZAN LAYER 5
	current_health -= amount
	damaged = true
	print("Do recibió ", amount, " de daño. Vida restante: ", current_health)
	
	health_changed.emit(current_health)

	if current_health <= 0:
		die()

func die():
	defeated.emit()
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
