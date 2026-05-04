extends Area2D

# Arraste o seu Marker2D para cá ou selecione no Inspetor
@export var destino: Marker2D 

func _ready():
	# Conecta o sinal para saber quando o boneco encostou na porta
	body_entered.connect(_ao_entrar_na_porta)

func _ao_entrar_na_porta(body):
	# Verifica se quem entrou foi o seu personagem
	if body.name == "CharacterBody2D2":
		if destino != null:
			# O PULO DO GATO: Muda a posição do boneco para a do destino
			body.global_position = destino.global_position
			print("Teletransportado para: ", destino.name)
		else:
			print("ERRO: Você esqueceu de selecionar o destino no Inspetor!")
