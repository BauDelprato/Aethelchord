extends Node

var sfx_lyra_respawn = preload("res://sound/effects/respawn.ogg")
var sfx_lyra_died = preload("res://sound/effects/defeated.ogg")
var sfx_c_attack_unlocked = preload("res://sound/effects/recibe_ataque.ogg")

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	Eventos.lyra_respawned.connect(_on_lyra_respawned)
	Eventos.lyra_died.connect(_on_lyra_died)
	Eventos.c_attack_unlocked.connect(_on_c_attack_unlocked)
	
func _on_lyra_respawned():
	player.stream = sfx_lyra_respawn
	player.play()

func _on_lyra_died():
	player.stream = sfx_lyra_died
	player.play()

func _on_c_attack_unlocked():
	player.stream = sfx_c_attack_unlocked
	player.play()
