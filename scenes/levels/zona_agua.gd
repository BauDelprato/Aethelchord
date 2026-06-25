extends Area2D

func _on_body_entered(body):
	if body.name == "Lyra": 
		matar_jugador()

func matar_jugador():
	print("¡Lyra se ahogó!")
	
	# poner función de muerte o daño
