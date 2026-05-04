extends CharacterBody2D

@export var velocidade = 180.0

var pallet_nas_maos = null
var jogador_na_area = null
var esta_dirigindo = false
var motorista_atual = null

@onready var sprite_motorista_cabine = $motorista

func _ready():
	$AreaEntrada.body_entered.connect(_ao_entrar_na_area)
	$AreaEntrada.body_exited.connect(_ao_sair_na_area)

	sprite_motorista_cabine.visible = false
	sprite_motorista_cabine.z_index = 1
	sprite_motorista_cabine.position = Vector2(5, 7)
	sprite_motorista_cabine.rotation_degrees = 0
	sprite_motorista_cabine.scale = Vector2(0.5, 0.5)	

	print("Empilhadeira pronta.")

func _physics_process(_delta):
	if esta_dirigindo:
		var direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direcao * velocidade
		move_and_slide()

		# Faz o boneco invisível acompanhar (câmera)
		if is_instance_valid(motorista_atual):
			motorista_atual.global_position = global_position

func _input(event):
	if event.is_action_pressed("interagir") and not event.is_echo():
		if not esta_dirigindo:
			if is_instance_valid(jogador_na_area):
				entrar_na_empilhadeira()
		else:
			sair_da_empilhadeira()

	if esta_dirigindo and event.is_action_pressed("ui_accept") and not event.is_echo():
		if pallet_nas_maos == null:
			tentar_pegar()
		else:
			soltar()

func entrar_na_empilhadeira():
	esta_dirigindo = true
	motorista_atual = jogador_na_area

	# Esconde jogador real
	motorista_atual.visible = false
	motorista_atual.set_physics_process(false)

	# Mostra motorista na cabine
	sprite_motorista_cabine.visible = true

	for child in motorista_atual.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", true)

	print("Motorista entrou!")

func sair_da_empilhadeira():
	if is_instance_valid(motorista_atual):
		esta_dirigindo = false

		# Esconde cabine
		sprite_motorista_cabine.visible = false

		# Volta jogador real
		motorista_atual.visible = true
		motorista_atual.set_physics_process(true)

		for child in motorista_atual.get_children():
			if child is CollisionShape2D or child is CollisionPolygon2D:
				child.set_deferred("disabled", false)

		# Sai do lado da empilhadeira
		motorista_atual.global_position = global_position + Vector2(120, 0)

		print("Motorista saiu!")
		motorista_atual = null

func _ao_entrar_na_area(body):
	if body.name == "CharacterBody2D2":
		jogador_na_area = body
		print("Perto da empilhadeira: ", body.name)

func _ao_sair_na_area(body):
	if body == jogador_na_area:
		jogador_na_area = null

func tentar_pegar():
	var alvos = $SensorGarfo.get_overlapping_bodies()

	for algo in alvos:
		if algo == self:
			continue

		if algo.is_in_group("pallets"):
			pallet_nas_maos = algo
			pallet_nas_maos.add_collision_exception_with(self)
			pallet_nas_maos.reparent($PontoGarfo)
			pallet_nas_maos.position = Vector2.ZERO
			pallet_nas_maos.rotation = 0
			$ColisaoPalletCarregado.set_deferred("disabled", false)

			print("Pegou o pallet!")
			return

	print("Nada para pegar aqui.")

func soltar():
	if is_instance_valid(pallet_nas_maos):
		pallet_nas_maos.remove_collision_exception_with(self)
		pallet_nas_maos.reparent(get_tree().current_scene)
		pallet_nas_maos.global_position = $PontoGarfo.global_position
		pallet_nas_maos = null
		$ColisaoPalletCarregado.set_deferred("disabled", true)

		print("Pallet solto.")
