extends CharacterBody2D

@export var velocidade: float = 80.0 # Um pouco mais lento que o jogador é o ideal
@export var tempo_roubado: float = 10 # Quantos segundos ele rouba por toque

@onready var sprite = $AnimatedSprite2D
var jogador = null
var pode_roubar = true # Sistema para ele não roubar 100 segundos em 1 segundo de colisão

func _ready():
	# Procura o jogador no mapa pelo grupo que criamos no Passo 1
	jogador = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta):
	# Só se move se o jogador existir no mapa
	if jogador != null:
		# Calcula a distância exata em X e Y entre o inimigo e o jogador
		var distancia = jogador.global_position - global_position
		var direcao = Vector2.ZERO
		
		# abs() transforma qualquer número negativo em positivo. 
		# Assim sabemos a distância real, independente do lado.
		if abs(distancia.x) > abs(distancia.y):
			# Se a distância Horizontal (X) for maior, ele anda para os lados
			direcao.x = sign(distancia.x) # sign() retorna 1 (direita) ou -1 (esquerda)
			
			if direcao.x > 0:
				sprite.play("andarD")
			else:
				sprite.play("andarE")
		else:
			# Se a distância Vertical (Y) for maior, ele anda para cima ou baixo
			direcao.y = sign(distancia.y) # sign() retorna 1 (baixo) ou -1 (cima)
			
			if direcao.y > 0:
				sprite.play("andarB")
			else:
				sprite.play("andarC")
		
		# Aplica a velocidade baseada na direção travada e move o personagem
		velocity = direcao * velocidade
		move_and_slide()

# Quando o sensor encostar no jogador...
func _on_sensor_roubo_body_entered(body):
	# O print aparece na aba "Output/Saída" lá embaixo no Godot quando você joga
	print("Alguém encostou no sensor: ", body.name) 
	
	if body.name == "Jogador" and pode_roubar:
		pode_roubar = false
		print("Roubo ativado!")
		
		# 1. Avisa o jogador para mostrar o reloginho na cabeça dele!
		if body.has_method("mostrar_relogio_roubado"):
			body.mostrar_relogio_roubado()
		
		# 2. Procura a interface e rouba o tempo
		var interface_jogo = get_tree().get_first_node_in_group("interface")
		if interface_jogo:
			print("Interface encontrada! Subtraindo tempo...")
			interface_jogo.perder_tempo(tempo_roubado)
		else:
			print("ERRO: O Godot não achou a Interface!")
		
		# Espera 2 segundos de cooldown
		await get_tree().create_timer(2.0).timeout
		pode_roubar = true
