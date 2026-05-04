extends Area2D

# Procura o texto na tela
@onready var label_missao = get_tree().current_scene.find_child("TextoIntro", true, false)
var ja_mostrou = false

func _ready():
	# Conecta para detectar quando o personagem (corpo) entrar
	body_entered.connect(_ao_passar_pelo_inicio)

func _ao_passar_pelo_inicio(body):
	# Só ativa se for o seu personagem e se ainda não mostrou
	if not ja_mostrou and body.name == "CharacterBody2D2":
		ja_mostrou = true
		
		if label_missao:
			# Define a mensagem inicial
			label_missao.text = "Hoje você vai começar trabalhando no depósito.\nSó organize os pallets!"
			label_missao.visible = true
			
			
			# Espera 6 segundos para o jogador ler com calma
			await get_tree().create_timer(3.5).timeout
			
			# Apaga a mensagem
			label_missao.visible = false
			
			# Opcional: Remove essa área do jogo para não gastar memória
			queue_free()
