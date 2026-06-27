extends Node2D
@onready var mapa = $tileMapLayers/Foreground
@onready var camara_jugador = $Lyra/Camera2D
@onready var ability_manager = $"Lyra/AbilityManager"

func _ready():
	var rectangulo_mapa = mapa.get_used_rect()
	var tamano_tile = mapa.tile_set.tile_size
	
	camara_jugador.limit_left = rectangulo_mapa.position.x * tamano_tile.x
	camara_jugador.limit_top = rectangulo_mapa.position.y * tamano_tile.y
	camara_jugador.limit_right = rectangulo_mapa.end.x * tamano_tile.x
	camara_jugador.limit_bottom = rectangulo_mapa.end.y * tamano_tile.y
	
	ability_manager.enabled = true
	
	if Global.volviendo_de_minijuego == true:
		$Lyra.global_position = Global.posicion_jugador
		Global.volviendo_de_minijuego = false
		
	if Global.volviendo_de_alcantarilla == true:
		$Lyra.global_position = Global.posicion_jugador2
		Global.volviendo_de_alcantarilla = false
