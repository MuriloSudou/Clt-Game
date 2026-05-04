extends StaticBody2D

# 1. Ensina a máquina onde está o arquivo do prego (Verifique se o nome/pasta está certo!)
var cena_prego = preload("res://industria/Prego.tscn")

#@onready var cano_cima = $CanoCima
@onready var cano_baixo = $CanoBaixo

# SINAL DO TIMER: Roda a cada 1.5 segundos
func _on_timer_timeout():
	# Atira um prego para cima e um para baixo ao mesmo tempo!
	#atirar(cano_cima.global_position, Vector2.UP)
	atirar(cano_baixo.global_position, Vector2.DOWN)

func atirar(posicao_inicial, direcao_tiro):
	# 1. Cria uma cópia do prego
	var novo_prego = cena_prego.instantiate()
	
	# 2. Coloca o prego exatamente na posição do cano
	novo_prego.global_position = posicao_inicial
	
	# 3. Informa para qual lado o prego deve voar
	novo_prego.direcao =  direcao_tiro
	
	# Gira o prego se ele estiver indo para baixo, para a ponta ficar pro lado certo
	if direcao_tiro == Vector2.DOWN:
		novo_prego.rotation_degrees = 180
	
	# 4. Adiciona o prego no mapa principal (e não dentro da máquina)
	get_tree().current_scene.add_child(novo_prego)
