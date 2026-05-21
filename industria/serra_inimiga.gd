extends CharacterBody2D

@export var velocidade: float = 250.0

var direcao: Vector2
@onready var sprite = $Sprite2D # Lembre de mudar para $AnimatedSprite2D se o seu for animado!

func _ready():
	# 1. Escolhe um ângulo totalmente aleatório (em radianos) para começar
	var angulo_aleatorio = randf_range(0, 2 * PI)
	
	# 2. Converte o ângulo em uma direção X e Y
	direcao = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)).normalized()

func _physics_process(delta):
	# Opcional: Faz a imagem da serra girar loucamente!
	sprite.rotation += 15.0 * delta
	
	# 3. Move a serra. A função "move_and_collide" avisa se bateu em algo.
	var colisao = move_and_collide(direcao * velocidade * delta)
	
	# 4. Se bateu na parede...
	if colisao:
		# Rebate a direção como uma bola de sinuca
		direcao = direcao.bounce(colisao.get_normal())

# --- LÓGICA DE DANO FÍSICO ---

# --- LÓGICA DE DANO FÍSICO ---
func _on_sensor_dano_body_entered(body):
	# Coloquei esse print para te ajudar a investigar!
	print("A serra encostou em algo chamado: ", body.name)
	
	# Não perguntamos mais o nome. Só perguntamos se ele sabe apanhar:
	if body.has_method("tomar_dano"):
		print("O alvo sabe tomar dano! Cortando...")
		body.tomar_dano()
# --- SISTEMA DE PARRY DA SERRA ---
func sofrer_parry(posicao_do_jogador: Vector2):
	print("🪚 A serra levou parry e inverteu a direção!")
	
	# Inverte a velocidade (se ia para a frente, vai para trás e vice-versa)
	velocidade = -velocidade
	
	# Vira a imagem da serra para o lado correto
	sprite.flip_h = !sprite.flip_h
	
	# Dá um empurrãozinho instantâneo de 30 pixels para ela desgrudar do jogador
	var direcao_empurrao = sign(global_position.x - posicao_do_jogador.x)
	if direcao_empurrao == 0: 
		direcao_empurrao = 1
	global_position.x += direcao_empurrao * 30
	
	# Como ela virou de costas, o ponto inicial dela tem de ser redefinido 
	# para ela não se teletransportar acidentalmente
	#posicao_inicial = global_position
