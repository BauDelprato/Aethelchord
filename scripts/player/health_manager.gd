extends Node2D
#CLASE MANEJADORA DE SALUD
signal died
signal health_changed(current)

@export var max_health := 3
@export var current_health := max_health

func take_damage(amount):

	current_health -= amount

	health_changed.emit(current_health)

	if current_health <= 0:
		died.emit()
