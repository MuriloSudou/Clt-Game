extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var icone_alerta = $IconeAlerta
@onready var zona_conserto = $ZonaDeConserto
@onready var timer_game_over = $TimerGameOver
@onready var timer_quebra = $TimerQuebra

# NOVAS VARIÁVEIS DE SOM
@onready var som_trabalhando = $SomTrabalhando
@onready var som_quebrando = $SomQuebrando

var esta_quebrada: bool = false
var jogador_perto: bool = false
var posicao_original_sprite: Vector2
var socos_necessarios: int = 5
var socos_dados: int = 0

func _ready():
	posicao_original_sprite = sprite.position
	iniciar_ciclo_trabalho()
	print("MÁQUINA LIGADA E PRONTA!")
	


func iniciar_ciclo_trabalho():
	esta_quebrada = false
	socos_dados = 0 # Zera a contagem de socos toda vez que ela liga!
	sprite.modulate = Color.WHITE
	icone_alerta.hide()
	timer_game_over.stop()
	
	# Lógica de Áudio
	som_quebrando.stop()
	if not som_trabalhando.playing:
		som_trabalhando.play()
	
	timer_quebra.wait_time = randf_range(10.0, 30.0)
	timer_quebra.start()

func _process(_delta):
	if not esta_quebrada:
		sprite.position = posicao_original_sprite + Vector2(randf_range(-2, 2), randf_range(-2, 2))
	else:
		sprite.position = posicao_original_sprite
		var tempo = Time.get_ticks_msec() / 150.0
		var brilho = (sin(tempo) + 1.0) / 2.0 
		var cor_alerta = Color(1.0, 1.0 - brilho, 1.0 - brilho)
		
		sprite.modulate = cor_alerta
		icone_alerta.modulate = cor_alerta

func quebrar_maquina():
	esta_quebrada = true
	icone_alerta.show()
	timer_game_over.start(20.0)
	
	# --- LÓGICA DE ÁUDIO ---
	som_trabalhando.stop() # Para o motor
	som_quebrando.play()   # Toca o alarme/quebra

func _input(event):
	# Se apertou a tecla de bater perto da máquina quebrada:
	if esta_quebrada and jogador_perto and event.is_action_pressed("ui_accept"):
		socos_dados += 1 # Adiciona 1 soco na conta
		print("POW! Soco ", socos_dados, " de ", socos_necessarios)
		
		# Se deu os 3 socos...
		if socos_dados >= socos_necessarios:
			print("A Máquina voltou a funcionar no tranco!")
			iniciar_ciclo_trabalho()

# --- SINAIS DO TIMER ---
func _on_timer_quebra_timeout():
	quebrar_maquina()

func _on_timer_game_over_timeout():
	print("GAME OVER! A máquina explodiu!")
	get_tree().reload_current_scene()

# --- A CORREÇÃO DE COLISÃO DO JOGADOR ESTÁ AQUI ---
func _on_zona_de_conserto_body_entered(body):
	# Em vez de perguntar o nome e errar a letra maiúscula, checamos a habilidade
	if body.has_method("tomar_dano"): 
		jogador_perto = true
		print("JOGADOR ENTROU NA ÁREA DA MÁQUINA")

func _on_zona_de_conserto_body_exited(body):
	if body.has_method("tomar_dano"):
		jogador_perto = false
		print("JOGADOR SAIU DA ÁREA DA MÁQUINA")


#func _on_zona_de_conserto_body_entered(body):
	# ISSO VAI IMPRIMIR ATÉ O CHÃO SE ELE ENCOSTAR!
	print("🚨 ALERTA: Algo tocou na área da máquina! O nome disso é: ", body.name)
	
	if body.has_method("tomar_dano"): 
		jogador_perto = true
		print("✅ CONFIRMADO: É o Jogador!")


#func _on_zona_de_conserto_body_exited(body):
	if body.has_method("tomar_dano"):
		jogador_perto = false
		print("JOGADOR SAIU DA ÁREA DA MÁQUINA")
