extends Area2D

@onready var som_sucesso = $SomSucesso

func _ready():
	# Conecta o sinal de quando algum corpo físico entra na área
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verifica se quem entrou na área tem a etiqueta "caixas"
	if body.is_in_group("caixas"):
		# Se for uma caixa:
		som_sucesso.play() # Toca o som de vitória
		body.queue_free()  # Destrói a caixa (ela "sumiu" porque foi entregue!)
		# ---- NOVO CÓDIGO AQUI ----
		# Procura quem é a interface do jogo e manda adicionar um ponto!
		var placar = get_tree().get_first_node_in_group("interface")
		if placar:
			placar.adicionar_ponto()
		print("Ponto! Uma caixa foi entregue!")
