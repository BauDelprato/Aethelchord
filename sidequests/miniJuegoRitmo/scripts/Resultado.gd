extends Control

@onready var titulo = $Label
@onready var btn_reintentar = $VBoxContainer/Reintentar
@onready var btn_salir = $VBoxContainer/Salir

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Evaluamos la variable global
	if Global.minijuego_ganado:
		titulo.text = "¡Logrado! \n:) "
		btn_reintentar.hide()
		btn_salir.text = "Continuar" 
	else:
		titulo.text = "Intentalo de nuevo :("
		btn_reintentar.show()
		btn_salir.text = "Salir"


func _on_button_reintentar_pressed(): 
	Global.score = 0
	Global.combo = 0
	
	if get_tree().change_scene_to_file("res://sidequests/miniJuegoRitmo/scenes/Game.tscn") != OK:
		print("Error al recargar el minijuego")

func _on_button_salir_pressed():
	if get_tree().change_scene_to_file("res://scenes/menus/titleScreen.tscn") != OK:
		print("Error al salir del minijuego")
