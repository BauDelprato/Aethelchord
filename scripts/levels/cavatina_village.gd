extends Node2D
@onready var camara_jugador = $Lyra/Camera2D 
#los limites estan puestos manualmente 
@export_category("Scene Limits")
@export var limit_left: int = -768.0
@export var limit_right: int = 3088.0
@export var limit_top: int = -570.0
@export var limit_bottom: int = 191.0

func _ready() -> void:
	camara_jugador.limit_left = limit_left
	camara_jugador.limit_right = limit_right
	camara_jugador.limit_top = limit_top
	camara_jugador.limit_bottom = limit_bottom
	
	
