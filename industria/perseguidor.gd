extends CharacterBody2D

@export var velocidade: float = 80.0 
@export var tempo_roubado: float = 10 

@onready var sprite = $AnimatedSprite2D
var jogador = null
var pode_roubar = true 
var atordoado = false # <--- AQUI ESTÁ A CHAVE DO MISTÉRIO!

func _ready():
	jogador = get_tree().get_first_node_in_group("jogador")

func _physics_process(_delta):
	# --- NOVA TRAVA DE ATORDOAMENTO ---
	# Se ele levou parry, ele só voa para trás e ignora o jogador por um tempinho!
	if atordoado:
		move_and_slide()
		return 
	# ----------------------------------

	if jogador != null:
		var distancia = jogador.global_position - global_position
		var direcao = Vector2.ZERO
		
		if abs(distancia.x) > abs(distancia.y):
			direcao.x = sign(distancia.x) 
			if direcao.x > 0:
				sprite.play("andarD")
			else:
				sprite.play("andarE")
		else:
			direcao.y = sign(distancia.y) 
			if direcao.y > 0:
				sprite.play("andarB")
			else:
				sprite.play("andarC")
		
		velocity = direcao * velocidade
		move_and_slide()

# Quando o sensor encostar no jogador...
func _on_sensor_roubo_body_entered(body):
	# Em vez de olhar para o nome, olhamos para a "etiqueta" (grupo) do corpo!
	if body.is_in_group("jogador"):
		
		if pode_roubar:
			pode_roubar = false 
			print("⏱️ Roubo ativado pelo GRUPO!")
			
			if body.has_method("mostrar_relogio_roubado"):
				body.mostrar_relogio_roubado()
			
			var interface_jogo = get_tree().get_first_node_in_group("interface")
			if interface_jogo:
				interface_jogo.perder_tempo(tempo_roubado)
			
			await get_tree().create_timer(2.0).timeout
			pode_roubar = true
		
func sofrer_parry(posicao_do_jogador: Vector2):
	print("😵 Fui rebatido!")
	
	var direcao_empurrao = (global_position - posicao_do_jogador).normalized()
	
	# Aplica uma força gigante para trás e LIGA o modo atordoado!
	velocity = direcao_empurrao * 2000 
	atordoado = true 
	
	# O inimigo fica voando para trás sem controle por 0.3 segundos
	await get_tree().create_timer(1).timeout
	
	# Passou o tempo? Ele freia e acorda!
	velocity = Vector2.ZERO 
	atordoado = false
