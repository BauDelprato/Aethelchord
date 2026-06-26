extends Node 

@onready var barra_vida = $ProgressBar 

@export var health_manager: Node

func _ready():
	if health_manager == null:
		print("Advertencia: No se asignó un Health Manager a la interfaz del jefe.")
		return
		
	barra_vida.max_value = health_manager.max_health
	barra_vida.value = health_manager.current_health
	health_manager.health_changed.connect(_on_health_changed)

func _on_health_changed(current):
	barra_vida.value = current
