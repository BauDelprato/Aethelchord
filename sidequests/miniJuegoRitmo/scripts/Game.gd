extends Node2D

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var note = load("res://sidequests/miniJuegoRitmo/scenes/Note.tscn")
var ultimo_beat_registrado = -1.0
var canales_disponibles = []

func _ready():
	randomize()
	
	$Conductor.spawn_note.connect(_on_Conductor_spawn_note)
	
	$Conductor.finished.connect(_on_Conductor_finished)
	
	$Conductor.play_with_beat_offset(4)


func _input(event):
	if event.is_action("escape"):
		if get_tree().change_scene_to_file("res://scenes/menus/titleScreen.tscn") != OK:
			print ("Error changing scene to Menu")


func _on_Conductor_spawn_note(_target_beat):
	_spawn_notes(_target_beat)


func _spawn_notes(_target_beat):
	if _target_beat != ultimo_beat_registrado:
		ultimo_beat_registrado = _target_beat
		canales_disponibles = [0, 1, 2] 
		canales_disponibles.shuffle() 
	
	if canales_disponibles.is_empty():
		return
	var lane = canales_disponibles.pop_back() #con esto los carriles no se repiten
	var instance = note.instantiate()
	instance.initialize(lane)
	add_child(instance)


func _on_Conductor_finished():
	var total_notas = $Conductor.notas_cancion.size()
	var max_score_posible = 3 * (total_notas * (total_notas + 1)) / 2
	
	var porcentaje = (float(score) / max_score_posible) * 100.0
	
	print("Puntaje obtenido: ", score, " / ", max_score_posible)
	print("Porcentaje de precisión: ", porcentaje, "%")
	
	if porcentaje >= 10.0:
		Global.minijuego_ganado = true
	else:
		Global.minijuego_ganado = false
		
	Global.set_score(score) 
	Global.combo = max_combo
	Global.great = great
	Global.good = good
	Global.okay = okay
	Global.missed = missed
	
	if get_tree().change_scene_to_file("res://sidequests/miniJuegoRitmo/scenes/Resultado.tscn") != OK:
		print ("Error changing scene to Resultado")


func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	score += by * combo
	$Label.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""


func reset_combo():
	combo = 0
	$Combo.text = ""


func _on_Conductor_beat(position: Variant) -> void:
	pass # Replace with function body.


func _on_Conductor_measure(position: Variant) -> void:
	pass # Replace with function body.
