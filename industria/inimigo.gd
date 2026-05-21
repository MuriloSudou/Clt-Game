extends Area2D

# Pega a referência do nó de desenho (Sprite2D) que é filho do Inimigo
@onready var sprite = $Sprite2D

# O @export faz essas variáveis aparecerem no painel Inspector!
# Assim você pode mudar a velocidade de cada inimigo individualmente no mapa.
@export var velocidade: float = 150.0
@export var distancia_maxima: float = 600.0 

var posicao_inicial: Vector2

func _ready():
	# Salva a posição inicial (isso você já tinha)
	posicao_inicial = global_position
	
	# Conecta o sinal de colisão (isso você já tinha)
	body_entered.connect(_on_body_entered)

	# --- NOVA LÓGICA DE INVERTER AQUI ---
	
	# ATENÇÃO: Essa lógica supõe que o seu desenho original 
	# (a imagem PNG) está olhando para a DERECHA.

	if velocidade < 0:
		# Se a velocidade é negativa, ele vai para a esquerda.
		# Então nós ATIVAMOS o flip_h (Inverter Horizontalmente)
		sprite.flip_h = true
	else:
		# Se a velocidade é zero ou positiva, ele vai para a direita.
		# Então nós DESACTIVAMOS o flip_h
		sprite.flip_h = false

func _process(delta):
	# Move o inimigo no eixo X (Esquerda/Direita)
	global_position.x += velocidade * delta
	
	# Se ele andou mais do que a distância máxima, teletransporta de volta pro começo
	if abs(global_position.x - posicao_inicial.x) >= distancia_maxima:
		global_position = posicao_inicial

func _on_body_entered(body):
	if body.name == "Jogador":
		# Em vez de game over direto, manda o jogador tomar dano!
		if body.has_method("tomar_dano"):
			body.tomar_dano() 
			
	# --- NOVO: SISTEMA DE FOGO AMIGO ---
	# Se quem encostou tem a função de voar (Perseguidor) e não é o próprio Inimigo
	elif body.has_method("sofrer_parry") and body.name != self.name:
		print("💥 O Inimigo de patrulha atropelou o Perseguidor!")
		body.sofrer_parry(global_position) # Manda o Perseguidor voar!
	# -----------------------------------
