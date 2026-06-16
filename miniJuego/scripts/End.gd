extends Node2D

func _ready():
	var aciertos = Global.aciertos
	var total = Global.total_notas
	
	# Muestra el texto "15 / 20"
	$TextoResumen.text = str(aciertos) + " / " + str(total)
	
	# Lógica para superar la prueba (ejemplo: acertar el 70% o más)
	var porcentaje_necesario = 0.8 
	var aciertos_necesarios = total * porcentaje_necesario
	
	if aciertos >= aciertos_necesarios:
		$TextoPrueba.text = "¡PRUEBA SUPERADA!"
		$TextoPrueba.modulate = Color(0, 1, 0) # Lo pinta de verde
	else:
		$TextoPrueba.text = "PRUEBA FALLIDA"
		$TextoPrueba.modulate = Color(1, 0, 0) # Lo pinta de rojo



func _on_PlayAgain_pressed():
	if get_tree().change_scene_to_file("res://miniJuego/scenes/Game.tscn") != OK:
			print ("Error changing scene to Game")


func _on_BackToMenu_pressed():
	if get_tree().change_scene_to_file("res://Scenes/Menu.tscn") != OK:
			print ("Error changing scene to Menu")
