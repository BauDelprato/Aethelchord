extends Node 

@onready var barra_vida = $CanvasLayer/Sprite2D/ProgressBar

var health_manager: Node2D

func _ready():
	health_manager = owner.get_node("HealthManager")
	
	if health_manager == null:
		print("ERROR CRÍTICO: La interfaz no pudo encontrar al HealthManager usando 'owner'")
		return
		
	barra_vida.max_value = health_manager.max_health
	barra_vida.value = health_manager.current_health

	health_manager.health_changed.connect(_on_health_changed)

func _on_health_changed(current):
	barra_vida.value = current
