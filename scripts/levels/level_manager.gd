extends Node
#CLASE QUE MANEJA TRANSICIONES ENTRE NIVELES (ESCENAS DE NIEVELES)
#⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈⇈ #es un autoloead (global) asiq se puede usar desde cualquier scripty

var changing_level := false

func load_level(path : String):
	if changing_level:
		return
	changing_level = true
	# ACA iría una animaciónd e transición
	get_tree().change_scene_to_file(path)
	changing_level = false#para llamar escribir LevelManager.load_level("nombre_de_la_escena.tscn")
