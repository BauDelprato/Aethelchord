extends Node2D

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var note = load("res://sidequests/miniJuegoRitmo/scenes/Note.tscn")
var canales_disponibles = []
var ultimo_beat_registrado = -1.0
var ultimo_carril_usado = -1
var carriles_usados_en_este_beat = []

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


func _spawn_notes(target_beat):
	if abs(target_beat - ultimo_beat_registrado) > 0.15:
		ultimo_beat_registrado = target_beat
		carriles_usados_en_este_beat.clear()
		
	var carriles_posibles = [0, 1, 2]
	
	for c in carriles_usados_en_este_beat:
		carriles_posibles.erase(c)
		
	if carriles_posibles.size() > 1 and carriles_posibles.has(ultimo_carril_usado):
		carriles_posibles.erase(ultimo_carril_usado)
		
	#(por si el MIDI manda un acorde de 4 notas)
	if carriles_posibles.is_empty():
		carriles_posibles = [0, 1, 2]
		
	var lane = carriles_posibles.pick_random()
	
	carriles_usados_en_este_beat.append(lane)
	ultimo_carril_usado = lane
	
	var instance = note.instantiate()
	instance.initialize(lane)
	add_child(instance)


func _on_Conductor_finished():
	var total_notas = $Conductor.notas_cancion.size()
	var max_score_posible = 3 * (total_notas * (total_notas + 1)) / 2
	
	var porcentaje = (float(score) / max_score_posible) * 100.0
	
	print("Puntaje obtenido: ", score, " / ", max_score_posible)
	print("Porcentaje de precisión: ", porcentaje, "%")
	
	if porcentaje >= 30.0:
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
