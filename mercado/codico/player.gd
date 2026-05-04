extends CharacterBody2D

# Velocidade de movimento do personagem
const SPEED = 250.0

# Referência ao nó de animação (o @onready garante que o nó carregou antes de ser usado)
@onready var animacao = $AnimatedSprite2D

# Variáveis para gerenciar o estado da interação
var lixo_perto: Node2D = null
var lixo_segurando: Node2D = null
var lixeira_perto: Node2D = null # <--- Nova variável para a lixeira

func _physics_process(_delta: float) -> void:
	# 1. MOVIMENTO
	# get_vector já pega as 4 direções e normaliza a diagonal (para não andar mais rápido na diagonal)
	var direcao = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Aplica a velocidade multiplicando a direção escolhida pela variável SPEED
	velocity = direcao * SPEED
	
	# Faz o personagem se mover e colidir com paredes
	move_and_slide()

	# 2. ANIMAÇÕES
	if velocity.length() > 0: # Se o personagem estiver se movendo
		
		if velocity.x > 0:
			animacao.play("runD") # Indo para a Direita
			animacao.flip_h = false # Mantém o sprite normal
			
		elif velocity.x < 0:
			animacao.play("runE") # Indo para a Esquerda
			animacao.flip_h = false  # Espelha o sprite para ele olhar para a esquerda
			
		elif velocity.y > 0:
			animacao.play("runB") # Indo para Baixo 
			
		elif velocity.y < 0:
			animacao.play("runC") # Indo para Cima 
			
	else:
		# Se não estiver apertando nenhum botão de andar
		animacao.play("idle") # Toca animação de parado
		
	# 3. INTERAÇÃO (Pegar, Soltar ou Depositar)
	if Input.is_action_just_pressed("interagir"):
		if lixo_segurando != null:
			# Se estou segurando lixo e perto da lixeira, deposita!
			if lixeira_perto != null:
				depositar_lixo()
			# Se não tem lixeira perto, apenas solta no chão.
			else:
				soltar()
		elif lixo_perto != null:
			pegar()


# --- MÉTODOS DE INTERAÇÃO ---

func pegar():
	lixo_segurando = lixo_perto
	
	# Desativa a física e TOCA O SOM de pegar
	lixo_segurando.desativar_fisica()
	lixo_segurando.tocar_som_pegar()
	
	# Gruda o lixo no jogador
	lixo_segurando.reparent(self, false)
	lixo_segurando.position = Vector2(30, 0)

func soltar():
	var mapa = get_parent()
	
	# Devolve o lixo para o mapa
	lixo_segurando.reparent(mapa, true)
	lixo_segurando.global_position = global_position + Vector2(40, 0)
	
	# Ativa a física e TOCA O SOM de soltar/cair
	lixo_segurando.ativar_fisica()
	lixo_segurando.tocar_som_soltar()
	
	# Esvazia a mão
	lixo_segurando = null

func depositar_lixo():
	
	# --- NOVA LINHA ---
	# Avisa o Mapa (que é o pai do personagem) para contar o ponto
	get_parent().registrar_lixo_depositado()
	
	# 1. Manda a lixeira tocar o som de sucesso!
	lixeira_perto.tocar_som()
	
	# 2. Destrói o lixo
	lixo_segurando.queue_free()
	
	# 3. Esvazia as mãos do funcionário
	lixo_segurando = null
	print("Lixo depositado com sucesso na lixeira!")


# --- SINAIS ---

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		# Pega a posição do marcador que está na cena
		var destino = get_parent().get_node("DestinoInterno")
		
		if destino:
			global_position = destino.global_position
			print("Teletransportado!")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == self:
		# Pega a posição do marcador que está na cena
		var destino = get_parent().get_node("Marker2d")
		
		if destino:
			global_position = destino.global_position
			print("Teletransportado!")
		pass # Replace with function body.
