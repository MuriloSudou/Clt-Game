extends Area2D

@export var velocidade: float = 400.0
var direcao: Vector2 = Vector2.ZERO # Quem vai decidir a direção é a pregadeira!

func _physics_process(delta):
	# O prego voa na direção escolhida
	position += direcao * velocidade * delta

# SINAL 1: Quando bater em algo
func _on_body_entered(body):
	# Se for o jogador, causa dano!
	if body.name == "Jogador":
		if body.has_method("tomar_dano"):
			body.tomar_dano()
	
	# Independente do que ele bater (jogador, parede, caixa), o prego se destrói
	queue_free()

# SINAL 2: Quando sair da tela (para não pesar a memória do jogo)
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
