extends CharacterBody2D

# Preload carrega o arquivo da cena. 
# ATENÇÃO: Verifique se o nome do seu arquivo é exatamente "caixa.tscn"
const CENA_CAIXA = preload("res://industria/caixa.tscn")
const SPEED = 300
const FORCA_EMPURRAO = 900.0

@onready var som_soco = $SomSoco # <--- ADICIONE ESTA LINHA AQUI!
@onready var animacao = $AnimatedSprite2D
@onready var hitbox = $HitBox
@onready var hitbox_colisao = $HitBox/HitBox	
@onready var item_segurado = $ItemSegurado
var vida: int = 6
@onready var som_dano = $SomDano
@onready var icone_relogio = $MenosRelogio
@onready var mais_relogio = $MaisRelogio
var tamanho_base_relogio_bom: Vector2
@onready var icone_cafe = $IconeCafe
@onready var timer_cafe = $TimerCafe
@onready var velocidade_atual = SPEED # Começa com a velocidade normal
@onready var icone_escudo = $IconeEscudo
@onready var timer_escudo = $TimerEscudo
var tem_escudo = false # O jogador começa sem escudo

var tamanho_base_relogio: Vector2
var esta_batendo = false
var segurando_item = false
var ultima_direcao = "B" # Começa olhando para Baixo

func _physics_process(_delta: float) -> void:
	if esta_batendo:
		return # Trava o movimento se estiver no meio de um soco/pegando

	# COMANDO DE BATER (Espaço/Enter)
	if Input.is_action_just_pressed("ui_accept"):
		if not segurando_item: # Só permite bater se as mãos estiverem livres!
			bater()
		return
		
	# COMANDO DE SOLTAR O ITEM (Tecla 'E')
	if Input.is_action_just_pressed("interagir"):
		if segurando_item: # Só solta se tiver algo na mão!
			soltar_item()
		return
	
	
	# MOVIMENTO
	var direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direcao * velocidade_atual
	move_and_slide()

	# ANIMAÇÕES DE ANDAR E POSIÇÃO DO HITBOX
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animacao.play("runD")
				animacao.flip_h = false
				ultima_direcao = "D"
				hitbox.position = Vector2(20, 0) # Hitbox vai para a direita
			else:
				animacao.play("runE")
				animacao.flip_h = false
				ultima_direcao = "E"
				hitbox.position = Vector2(-20, 0) # Hitbox vai para a esquerda
		else:
			if velocity.y > 0:
				animacao.play("runB")
				ultima_direcao = "B"
				hitbox.position = Vector2(0, 20) # Hitbox vai para baixo
			else:
				animacao.play("runC")
				ultima_direcao = "C"
				hitbox.position = Vector2(0, -20) # Hitbox vai para cima
	else:
		animacao.play("idle")


# FUNÇÃO DE BATER E EMPURRAR
func bater():
	esta_batendo = true
	velocity = Vector2.ZERO 
	
	# Toca a animação certa
	if ultima_direcao == "D": animacao.play("baterD")
	elif ultima_direcao == "E": animacao.play("baterE")
	elif ultima_direcao == "B": animacao.play("baterB")
	elif ultima_direcao == "C": animacao.play("baterC")

	hitbox_colisao.disabled = false # Liga a área do soco
	await get_tree().create_timer(0.1).timeout # Espera um instante
	
	# Checa se bateu na caixa
	var corpos_atingidos = hitbox.get_overlapping_bodies()
	var acertou_algo = false # Cria uma flag para sabermos se bateu em algo
	
	for corpo in corpos_atingidos:
		if corpo is RigidBody2D: # Se for a caixa (física solta)
			var direcao_forca = hitbox.position.normalized()
			corpo.apply_central_impulse(direcao_forca * FORCA_EMPURRAO)
			acertou_algo = true 
			
		elif corpo is StaticBody2D: # ADICIONE ESTAS DUAS LINHAS! Se bater em algo estático (como a Máquina)
			acertou_algo = true 
			
	for area in hitbox.get_overlapping_areas():
		if area.has_method("sofrer_parry"):
			area.sofrer_parry(global_position)


	# Se depois de checar tudo, a flag for verdadeira, toca o som!
	if acertou_algo:
		som_soco.play()
	# --- NOVO PARRY ATIVO ---
	# A sua HitBox procura quem está na área do soco
	for corpo in hitbox.get_overlapping_bodies():
		if corpo.has_method("sofrer_parry"):
			corpo.sofrer_parry(global_position)
	# ------------------------
	
	await animacao.animation_finished 
	hitbox_colisao.disabled = true # Desliga a área do soco
	esta_batendo = false


# FUNÇÃO DE PEGAR O ITEM (Chamada pela Caixa)
func pegar_item(textura_do_item):
	if segurando_item:
		return 
		
	esta_batendo = true # Trava o jogador rapidinho
	segurando_item = true
	
	item_segurado.texture = textura_do_item
	item_segurado.visible = true 
	
	esta_batendo = false # Libera o jogador
	
	
func soltar_item():
	# 1. Tira a caixa da cabeça do personagem
	segurando_item = false
	item_segurado.visible = false
	
	# 2. Fabrica uma nova caixa usando o molde
	var nova_caixa = CENA_CAIXA.instantiate()
	
	# 3. Define onde a caixa vai aparecer (Exatamente na posição do jogador)
	# Coloquei um + 30 no Y para a caixa aparecer um pouquinho nos pés dele, e não na cabeça
	nova_caixa.global_position = global_position + Vector2(0, 40)
	
	# 4. Adiciona a caixa de volta no Mundo!
	# get_parent() pega o nó "Mundo" (que é o pai do Jogador) e coloca a caixa lá dentro.
	get_parent().add_child(nova_caixa)
	
func tomar_dano(atacante = null):
	# 1. O SISTEMA DE PARRY (A Mágica acontece aqui)
	if esta_batendo and atacante != null:
		if atacante.has_method("sofrer_parry"):
			atacante.sofrer_parry(global_position) # Manda o inimigo voar
			print("🛡️ PARRY BEM SUCEDIDO!")
			return # O 'return' aborta a função. Você NÃO perde vida!

	# 2. O SISTEMA DE ESCUDO (Que fizemos antes)
	if tem_escudo:
		print("🛡️ Dano bloqueado pelo escudo!")
		return
	
	if tem_escudo:
		print("🛡️ Dano bloqueado pelo escudo!")
		return # A palavra 'return' aborta a função aqui. O código de perder vida não roda!
	
	vida -= 1
	som_dano.play()

	# Procura a interface para atualizar o texto na tela
	var interface_jogo = get_tree().get_first_node_in_group("interface")
	if interface_jogo:
		interface_jogo.atualizar_vida(vida) # Vamos criar isso no Passo 3!

	if vida <= 0:
		interface_jogo.mostrar_game_over()
		return # Para a função por aqui se ele morreu

   # Se ele não morreu, dá uma piscada vermelha igual o inimigo!
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3)


func _on_sensor_roubo_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func mostrar_relogio_roubado():
	# 1. RESET CORRIGIDO: 
	# Agora resetamos para o tamanho PEQUENO que você ajustou no editor,
	# e não para o 100% gigante da imagem original.
	icone_relogio.scale = tamanho_base_relogio
	icone_relogio.modulate = Color(1, 1, 1, 1) # Reseta opacidade
	icone_relogio.visible = true
	
	var tween = create_tween()
	
	# 2. O PULSO (Aumenta e diminui relativo ao tamanho pequeno)
	
	# Usamos a matemática: tamanho_base * 1.5 (Aumenta 50% do tamanho pré-definido)
	tween.tween_property(icone_relogio, "scale", tamanho_base_relogio * 1.5, 0.15)
	
	# Volta pro tamanho base original pré-definido
	tween.tween_property(icone_relogio, "scale", tamanho_base_relogio, 0.15)
	
	# 3. O FADE OUT (Esvanecer)
	# (Essa parte continua igual, é a animação da transparência)
	tween.tween_property(icone_relogio, "modulate:a", 0.0, 0.5).set_delay(0.3)
	
	# 4. Esconde o nó de verdade quando acabar
	tween.tween_callback(icone_relogio.hide)
	
func mostrar_relogio_ganho():
	# Usa a imagem específica que você fez!
	mais_relogio.scale = tamanho_base_relogio_bom
	mais_relogio.modulate = Color(1, 1, 1, 1) # Deixa na cor original da sua imagem
	mais_relogio.visible = true
	
	var tween = create_tween()
	
	# O Pulso
	tween.tween_property(mais_relogio, "scale", tamanho_base_relogio_bom * 1.5, 0.15)
	tween.tween_property(mais_relogio, "scale", tamanho_base_relogio_bom, 0.15)
	
	# O Fade Out
	tween.tween_property(mais_relogio, "modulate:a", 0.0, 0.5).set_delay(0.3)
	tween.tween_callback(mais_relogio.hide)
	
func _ready():
	# ... (se você tiver outro código no ready, mantenha-o) ...
	
	# Salva o tamanho que o usuário ajustou no editor (o tamanho pequeno)
	tamanho_base_relogio = icone_relogio.scale
	
	# Garante que o relógio começa invisível
	icone_relogio.visible = false 
	
	tamanho_base_relogio_bom = mais_relogio.scale
	mais_relogio.visible = false
	
func dar_boost_cafe(duracao: float):
	velocidade_atual = SPEED * 2
	icone_cafe.show()
	timer_cafe.start(duracao)
	print("☕ Café tomado! Velocidade dobrada!")

func _on_timer_cafe_timeout():
	velocidade_atual = SPEED
	icone_cafe.hide()
	print("⚡ O efeito do café passou...")
	
func dar_boost_escudo(duracao: float):
	tem_escudo = true
	icone_escudo.show()
	timer_escudo.start(duracao)
	print("🛡️ Escudo ativado! Você está invencível por um tempo.")

func _on_timer_escudo_timeout():
	tem_escudo = false
	icone_escudo.hide()
	print("⚠️ O escudo quebrou/acabou!")
	


func _on_timer_letra_timeout() -> void:
	pass # Replace with function body.
