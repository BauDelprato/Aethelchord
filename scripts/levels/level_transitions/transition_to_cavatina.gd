extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Lyra":
		print("TRANSICION bosque -> cavatina") #debug, eliminar una vez que se compruebe que la transicion funciona
		LevelManager.load_level("res://scenes/levels/cavatina_village.tscn")
		#PASAR SIEMPRE RUTAS COMPLETAS 	
