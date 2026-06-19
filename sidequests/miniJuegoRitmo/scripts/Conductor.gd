extends AudioStreamPlayer

@export var bpm := 115
@export var measures := 4
var notas_cancion : Array[float] = []
var indice_nota_actual = 0
var beats_anticipacion = 4.0

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 0
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var current_measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)
signal spawn_note(target_beat) 


func _ready():
	sec_per_beat = 60.0 / bpm
	cargar_notas_desde_json("res://sidequests/miniJuegoRitmo/mapa1.json")
	#FORZAR LA CARGA DEL AUDIO 
	volume_db = -80.0 
	play()            
	stop()            
	volume_db = 0.0   
	play_with_beat_offset(beats_anticipacion)

func cargar_notas_desde_json(ruta: String):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if not file:
		print("Error: No se encontró el archivo JSON")
		return
		
	var json_string = file.get_as_text()
	var json_data = JSON.parse_string(json_string)
	if json_data == null:
		print("ERROR CRÍTICO: El archivo ", ruta, " no es un JSON válido. Revisá su formato.")
		return
	
	notas_cancion.clear()
	
	for track in json_data["tracks"]:
		if track["notes"].size() > 0:
			for nota in track["notes"]:
				var tiempo_en_segundos = nota["time"]
				
				# El JSON nos da la posición en segundos exactos.
				# Lo dividimos para convertirlo al formato de beats que usa tu lógica.
				var beat_exacto = tiempo_en_segundos / sec_per_beat
				notas_cancion.append(beat_exacto)
			
			break # Ya leímos la pista correcta, salimos del bucle
			
	print("¡Éxito! Se cargaron ", notas_cancion.size(), " notas de forma automática.")

func _process(_delta):
	var current_beat_float = 0.0
	
	if playing:
		current_beat_float = song_position / sec_per_beat
	elif not $StartTimer.is_stopped():
		var beats_left = (beats_before_start - song_position_in_beats) + ($StartTimer.time_left / sec_per_beat)
		current_beat_float = -beats_left
	else:
		return
		
	if indice_nota_actual < notas_cancion.size():
		var beat_objetivo = notas_cancion[indice_nota_actual]
		var momento_de_spawn = beat_objetivo - beats_anticipacion
		
		if current_beat_float >= momento_de_spawn:
			spawn_note.emit(beat_objetivo)
			indice_nota_actual += 1


func _physics_process(_delta):
	if not playing:
		return
		
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
	song_position -= AudioServer.get_output_latency()
	
	song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
	_report_beat()


func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if current_measure > measures:
			current_measure = 1
		beat.emit(song_position_in_beats)
		measure.emit(current_measure)
		last_reported_beat = song_position_in_beats
		current_measure += 1


func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(start_beat, offset):
	play()
	seek(start_beat * sec_per_beat)
	beats_before_start = offset
	current_measure = start_beat % measures


func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
