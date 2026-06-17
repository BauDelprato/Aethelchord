extends CharacterBody2D
class_name Player #LE ESTAMOS DANDO UN NOMBRE A NUESTRO PERSONAJE

#VELOCIDADES
var intVX : int = 10000 #VELOCIDAD DEL PERSONAJE EN HORIZONTAL
var intVY : int = 480 #VELOCIDAD DEL PERSONAJE EN VERTICAL
var intVX_Dash : int = 18000 #VELOCIDAD HORIZONTAL DEL DASH DEL PERSONAJE
var intVX_Dash_Attack : int = 12000


#FISICAS
var Jump_Height : int = 240 #ESTA ES LA ALTURA A LA QUE VA A PODER SALTAR EL PERSONAJE

#Coyote Time
var max_coyote_time = 0.2 #TIEMPO QUE EL PERSONAJE TIENE PARA SALTAR EN EL AIRE WEON
var coyote_time = 0.0 #ESTA VARIABLE SE ENCARGARÁ DE REINICIAR EL CONTADOR DEL COYOTE TIME

#ESTADOS
var intMove : int = 0 #ESTA VARIABLE INDICARÁ SI MI PERSONAJE ESTÁ QUIETO O SI SE ESTÁ MOVIENDO


#NODO DE ANIMACIÓN DE LA ESCENA
@onready var ani = $Sprite2D/Graficos #ESTA VARIABLE HACE REFERENCIA AL NODO DE GRÁFICOS
@onready var mirror = $Sprite2D #ESTA VARIABLE HACE REFERENCIA AL NODO SPRITE2D

var estado = "Normal" #ESTA VARIABLE ES LA MÁQUINA DE ESTADOS DEL JUGADOR(Normal,Agachado,Dash...etc)

#ATAQUES
#ESTE ES UN CONTADOR QUE ME DIRÁ CUANTAS VECES EXACTAMENTE PRESIONÉ EL BOTÓN DE ATACAR
var counter_hit : int = 0


#Limitadores
#CON ESTO LIMITO LA CANTIDAD DE DASH QUE PUEDE HACER MI PERSONAJE CUANDO NO ESTÁ EN EL SUELO
var Can_Dash : int = 1



#EFECTOS
#TIEMPO ACTUAL DEL DUPLICADOR
var Time_Actual_Dupli : float = 0
#TIEMPO MÁXIMO AL QUE DEBE LLEGAR EL TIME_ACTUAL_DUPLI PARA PODER DUPLICAR
var Time_Dupli : float = 0.05
#TIEMPO DE VIDA DEL DUPLICADO
var Time_Life_Dupli : float = 0.2


func _ready():#LA FUNCIÓN READY SOLO SE EJECUTA UNA VEZ
	#ESTAS TRES LINEAS DE CÓDIGO SE ASEGURA DE QUE EL JUGADOR NO TENGA ACTIVA LAS COLISIONES DE ATQ
	$"Col_Daño/Ataque_1".disabled = true
	$"Col_Daño/Ataque_2".disabled = true
	$"Col_Daño/Ataque_Slide".disabled = true


func _input(event): #ESTA FUNCIÓN SE ACTIVARÁ CADA VEZ QUE PRESIONEMOS UN BOTÓN
	
	#ESTA ES UNA CONDICIÓN QUE SE EJECUTARÁ EN CASO DE QUE PRESIONE EL BOTÓN DE ATACAR
	if Input.is_action_just_pressed("Atacar"):
		if is_on_floor(): #ESTA ES UNA CONDICIÓN QUE SE EJECUTARÁ SI ESTOY TOCANDO EL SUELO
			if estado != "Dash": #CONDICIÓN QUE DETECTA SI MI ESTADO NO ES IGUAL A DASH
				counter_hit += 1 #EL CONTADOR DE GOLPES SUBIRÁ A UNO
				estado = "Atacando" #EL ESTADO DEL JUGADOR SERÁ "ATACANDO"
				_animaciones() #EJECUTARÁ LA FUNCIÓN DE LAS ANIMACIONES DEL JUGADOR
			else: #DE LO CONTRARIO
				estado = "Dash_Attack" #EL ESTADO DEL JUGADOR SERÁ "DASH ATAQUE"
				_animaciones() #EJECUTA LAS ANIMACIONES DEL JUGADOR


func _physics_process(delta): #ESTA FUNCIÓN SE EJECUTA EN CADA FRAME DEL JUEGO Y TRABAJA LA FISICA
	
	
	#Nomas para asegurar de que cada vez que toque el suelo pueda volver hacer Dash
	if is_on_floor(): #DETECTA SI ESTOY TOCANDO SUELO
		Can_Dash = 1 #ME RECARGA A 1 LA VARIABLE CAN_DASH
	
	#DETECTA SI ESTOY PRESIONANDO ABAJO, SI ESTOY EN EL SUELO Y SI MI ESTADO ES NORMAL
	if Input.is_action_pressed("Abajo") and is_on_floor() and estado == "Normal":
		if estado != "Dash": #SI MI ESTADO NO ES IGUAL A DASH
			estado = "Agachado" #MI ESTADO SERÁ AGACHADO
		else: #DE LO CONTRARIO SI MI ESTADO ES IGUAL A DASH
			estado = "Dash" #MI ESTADO SERÁ IGUAL A DASH
		
	#DE LO CONTRARIO SI: SUELTAS EL BOTÓN "ABAJO" Y ESTÁS TOCANDO EL SUELO Y TU ESTADO ES "AGACHADO"
	elif Input.is_action_just_released("Abajo") and is_on_floor() and estado == "Agachado":
		estado = "Normal" # TU ESTADO SERÁ "NORMAL"
	
	if Input.is_action_pressed("Derecha"):#SÍ ESTÁS PRESIONANDO DERECHA
			intMove = 1 #LA VARIABLE INDICARÁ QUE VAS A LA DERECHA
			
	elif Input.is_action_pressed("Izquierda"):#DE LO CONTRARIO SÍ VAS A LA IZQUIERDA
			intMove = -1 #LA VARIABLE INDICARÁ QUE VAS A LA IZQUIERDA
	else: #SI NINGUNA DE ESAS CONDICIONES SE CUMPLEN ENTONCES HAZ ESTO
			intMove = 0 #LA VARIABLE INDICARÁ QUE NO TE ESTÁS MOVIENDO
	
	if Input.is_action_just_pressed("Dash"): #SÍ ESTOY PRESIONANDO EL BOTÓN "DASH"
		
		if Can_Dash > 0: #SI CAN_DASH ES MAYOR A CERO
			estado = "Dash" #MI ESTADO SERÁ IGUAL A DASH
			Can_Dash -= 1 #CAN_DASH SE RESTARÁ 1 PUNTO
		
		if estado == "Agachado": #SI MI ESTADO ES AGACHADO
			estado = "dash" #MI ESTADO DASH SERÁ IGUAL A DASH
	
	
	if estado == "Normal": #SI EL ESTADO DEL PERSONAJE ES NORMAL
		
		if is_on_floor(): #DETECTA SI EL JUGADOR ESTÁ TOCANDO EL SUELO
			coyote_time = max_coyote_time # EL CONTADOR DEL COYOTE TIME SE REINICIA
		else: #DE LO CONTRARIO SI NO ESTOY TOCANDO EL SUELO
			coyote_time -= delta #EL CONTADOR DEL COYOTE TIME EMPIEZA A DISMINUIR
		
		#SI INTMOVE NO ES IGUAL A CERO (QUIERE DECIR QUE MI PERSONAJE SE ESTÁ MOVIENDO)
		if intMove != 0:
			#LA VELOCIDAD HORIZONTAL VA A SER EL RESULTADO + O - DE INTVX, Y LUEGO SE MULTIPLICA POR DELTA
			velocity.x = (intVX * intMove) * delta
		elif intMove == 0: #DE LO CONTRARIO SI EL JUGADOR ESTÁ QUIETO
			velocity.x = 0 #LA VELOCIDAD HORIZONTAL ESTARÁ EN CERO
		
		if is_on_floor(): # DETECTA SI EL PERSONAJE ESTÁ EN EL SUELO
			velocity.y = 0 #LA VELOCIDAD HORIZONTAL SERÁ CERO (YA QUE ESTÁ TOCANDO SUELO)
			Can_Dash = 1 #EL CAN_DASH SERÁ 1 NUEVAMENTE
		else: #DE LO CONTRARIO SI ESTOY EN EL AIRE
			velocity.y += intVY * delta #LA VELOCIDAD VERTICAL SE IRÁ SUMANDO (YA QUE EL JUGADOR ESTÁ CAYENDO)
		
		if Input.is_action_just_pressed("Saltar"): #SE EJECUTA CUANDO SE PRESIONA EL BOTÓN DE SALTAR
			if is_on_floor() or (coyote_time > 0 and velocity.y >0.01): #SI ESTOY EN EL SUELO O SI EL COYOTE TIME NO ESTÁ EN CERO
				velocity.y = -Jump_Height #ESTA LINEA HACE QUE MI PERSONAJE SALTE
		
		if Input.is_action_just_released("Saltar") and velocity.y < 0: #SE EJECUTA SI ESTOY DEJANDO DE PRESIONAR EL BOTÓN DE SALTAR Y SI MI VELOCIDAD VERTICAL ES MENOR A CERO
			velocity.y = velocity.y * 0.5 #MULTIPLICA POR 0.5 LA VELOCIDAD QUE TENGA ACTUALMENTE V
		
		
		_animaciones() #Ejecuta las animaciones
		move_and_slide() #Ejecuta las fisicas programadas
	
	if estado == "Agachado":
		#DETECTA SI SE ESTÁ PRESIONANDO IZQUIERDA O DERECHA
		velocity.x = 0 #LA VELOCIDAD HORIZONTAL SERÁ CERO
		velocity.y = 0 #LA VELOCIDAD VERTICAL SERÁ CERO
		_animaciones() #SE EJECUTARÁ LA FUNCIÓN DE ANIMACIONES
		move_and_slide() #SE EJECUTARÁN LAS FISICAS
	
	if estado == "Dash": #DETECTA SI MI PERSONAJE ESTÁ HACIENDO DASH
		
		#SUMA EL VALOR DE LA VARIABLE POR DELTA
		Time_Actual_Dupli += delta
		
		velocity.y = 0 #VELOCIDAD VERTICAL ES CERO
		
		if mirror.flip_h == false: #EN CASO DE QUE EL PERSONAJE ESTÉ MIRANDO A LA DERECHA
			velocity.x = intVX_Dash * delta #EL MOVIMIENTO DEL PERSONAJE HACIA LA DERECHA
		else: #DE LO CONTRARIO SI ESTÁ VIENDO A LA IZQUIERDA
			velocity.x = -intVX_Dash * delta #MOVIMIENTO DEL PERSONAJE A LA IZQUIERDA
		
		_animaciones() #EJECUTA LA FUNCIÓN DE ANIMACIONES
		move_and_slide() #EJECUTA LA FISICA
		
		
		
	
	if estado == "Dash_Attack": #SÍ EL ESTADO DEL JUGADOR ES IGUAL A DASH
		velocity.y = 0 #LA VELOCIDAD VERTICA ES IGUAL A CERO
		
		if intVX_Dash_Attack > 0: #SÍ LA VELOCIDAD DE DASH ATACANDO ES MAYOR A CERO
			intVX_Dash_Attack -= 1000 #VA A IR RESTANDO 1000 PUNTOS A LA VARIABLE EN CADA FRAME
		else: #DE LO CONTRARIO SI LA VARIABLE DE VELOCIDAD DE DASH ATACANDO NO ES MAYOR A CERO
			intVX_Dash_Attack = 0 #LA VELOCIDAD SERÁ CERO (ES PARA ASEGURARSE DE QUE EL JUGADOR NO SE VAYA EN RETROCESO xD un bug)
		
		
		if mirror.flip_h == false: #¿Realmente hace falta que lo explique? son casi las 3AM y quiero dormir pipipipi
			velocity.x = intVX_Dash_Attack * delta
		else:
			velocity.x = -intVX_Dash_Attack * delta
		_animaciones()
		move_and_slide()
	
	#Esto es para poder ver el estado de mi personaje y así asegurarme de que todo funciona bien xd
	#print(estado)


func _animaciones():
	#ESTAS SON LAS VARIABLES LOCALES PARA ASIGNAR VELOCIDADES DISTINTAS A LAS ANIMACIONES, ES MÁS CÓMODO
	var idle : float = 0.8
	var dash : float = 2.5
	var slide : float = 1.8
	var air : float = 1.0
	var walk : float = 1.1
	var atacar : float = 1.8
	
	#ESTO DETECTA SI LA ANIMACION QUE SE ESTÁ REPRODUCIENDO NO ES "SLIDE"
	if ani.current_animation != "Slide":
		$"Col_Daño/Ataque_Slide".disabled = true #DESACTIVA EL NODO DE ATAQUE MIENTRAS SE DESLIZA EN CASO DE QUE QUEDE ACTIVO (OTRA PREVENCIÓN DE BUGS)
	
	#RESUMIDAMENTE, ESTAS SON TODAS LAS ANIMACIONES DEL PERSONAJE, ES FÁCIL DE ENTENDER :b
	if estado == "Normal":
		
		if intMove == 1:
			mirror.flip_h = false
			#Colision personaje
			$Colision.position.x = -5
			#ATAQUE 1 Y 2
			$"Col_Daño/Ataque_1".position.x = 24.25
			$"Col_Daño/Ataque_2".position.x = 18
			$"Col_Daño/Ataque_Slide".position.x = 9
		if intMove == -1:
			mirror.flip_h = true
			#Colision personaje
			$Colision.position.x = 5
			#ATAQUE 1 Y 2
			$"Col_Daño/Ataque_1".position.x = -24.25
			$"Col_Daño/Ataque_2".position.x = -18
			$"Col_Daño/Ataque_Slide".position.x = -9
		
		if velocity.x == 0 and is_on_floor() and not Input.is_action_pressed("Abajo"):
			ani.speed_scale = idle
			ani.play("Idle")
		elif velocity.x != 0 and is_on_floor():
			ani.speed_scale = walk
			ani.play("Run")
		
		if not is_on_floor():
			ani.speed_scale = air
			if velocity.y < 0:
				ani.play("Jump")
			else:
				ani.play("Fall")
		
	if estado == "Agachado":
		ani.speed_scale = idle
		var current_anim = ani.current_animation
		if current_anim != "Fase1_Agacharse" and current_anim != "Fase2_Agacharse":
			ani.play("Fase1_Agacharse")
		
	
	if estado == "Dash":
		
		ani.speed_scale = dash
		if is_on_floor():
			if Input.is_action_pressed("Abajo") and ani.current_animation != "Dash_Smoke_Ground":
				ani.speed_scale = slide
				ani.play("Slide")
			elif not Input.is_action_pressed("Abajo") and ani.current_animation != "Slide":
				ani.play("Dash_Smoke_Ground")
		else:
			ani.play("Dash_Air")
			
		
		if Time_Actual_Dupli >= Time_Dupli:
				Time_Actual_Dupli = 0
				crear_duplicado()
		
	
	if estado == "Atacando":
		ani.speed_scale = atacar
		ani.play("Idle_Ataque_1")
	
	if estado == "Dash_Attack":
		ani.speed_scale = atacar
		ani.play("Dash_Attack")
	
	
	if estado != "Atacando":
		if ani.current_animation != "Dash_Attack":
			$"Col_Daño/Ataque_1".disabled = true
		$"Col_Daño/Ataque_2".disabled = true
		
	
	



func _agachado_ani(delta): #ESTA ES UNA FUNCIÓN QUE HICE PARA LA ANIMACION DE AGACHARSE, YA QUE TIENE MÁS DE UNA ANIMACIÓN
	ani.speed_scale = 0.8
	ani.play("Fase2_Agacharse")



func _on_graficos_animation_finished(anim_name): #ESTO SE EJECUTA CADA VEZ QUE TERMINA UNA ANIMACIÓN
	match anim_name:
		"Dash_Smoke_Ground":
			estado = "Normal"
		"Dash_Air":
			estado = "Normal"
		"Dash_Attack":
			estado = "Normal"
			intVX_Dash_Attack = 12000
		
		"Slide":
			if Input.is_action_pressed("Abajo"):
				estado = "Agachado"
				ani.play("Fase2_Agacharse")
				Can_Dash = 1
			else:
				estado = "Normal"
				ani.play("Idle")
				Can_Dash = 1
			
		"Idle_Ataque_1":
			if counter_hit == 1:
				counter_hit = 0
				estado = "Normal"
			if counter_hit > 1:
				ani.play("Idle_Ataque_2")
		"Idle_Ataque_2":
			counter_hit = 0
			estado = "Normal"
			
		


func crear_duplicado():
	#CREA LOS DUPLICADOS (YA HICE UN TUTORIAL CON RESPECTO A ELLO, EL Link: "https://youtu.be/h7ZZxC7YLVk?si=Nx42-Ra-a7YbKrU_" )
	
	var duplicado = $Sprite2D.duplicate(true)
	duplicado.material = $Sprite2D.material.duplicate(true)
	duplicado.material.set_shader_parameter("opacity", 0.3)
	duplicado.material.set_shader_parameter("r", 0.0)
	duplicado.material.set_shader_parameter("g", 0.0)
	duplicado.material.set_shader_parameter("b", 0.8)
	duplicado.material.set_shader_parameter("mix_color", 0.7)
	duplicado.position.y += position.y
	
	if $Sprite2D.scale.x == -1:
		duplicado.position.x = position.x - duplicado.position.x
	else:
		duplicado.position.x += position.x
	duplicado.z_index -= 1
	get_parent().add_child(duplicado)
	await get_tree().create_timer(Time_Life_Dupli).timeout
	duplicado.queue_free()
