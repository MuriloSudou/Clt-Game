extends Area2D

# Pega a referência do som ambiente do estoque
@onready var som_ambiente = $SomAmbiente

func _ready() -> void:
	# Conecta os sinais de entrar e sair da área do estoque
	body_entered.connect(_ao_entrar_no_estoque)
	body_exited.connect(_ao_sair_do_estoque)
	
	# NOVO: Conecta o sinal que avisa quando o som terminou para forçar o loop
	som_ambiente.finished.connect(_ao_som_terminar)

# NOVO: Função que força a música a tocar de novo se o estoque não estiver vazio
func _ao_som_terminar():
	if not devera_parar_som():
		som_ambiente.play()

func _ao_entrar_no_estoque(body: Node2D) -> void:
	# Se for o jogador a pé
	if body.name == "CharacterBody2D2":
		if not som_ambiente.playing:
			som_ambiente.play()
			print("Jogador entrou a pé no Estoque!")
			
	# Se for uma empilhadeira E tiver alguém dirigindo ela
	elif "esta_dirigindo" in body:
		if body.esta_dirigindo and not som_ambiente.playing:
			som_ambiente.play()
			print("Jogador entrou dirigindo no Estoque!")

func _ao_sair_do_estoque(body: Node2D) -> void:
	# Se quem "saiu" foi o jogador ou a empilhadeira
	if body.name == "CharacterBody2D2" or "esta_dirigindo" in body:
		# Só desliga a música se REALMENTE não tiver nenhum dos dois lá dentro
		if devera_parar_som():
			som_ambiente.stop()
			print("Estoque vazio. Parando som ambiente.")

# Função inteligente que checa quem ainda está dentro do estoque
func devera_parar_som() -> bool:
	var corpos_dentro = get_overlapping_bodies()
	
	for c in corpos_dentro:
		# Se o jogador a pé ainda estiver aqui, não para o som
		if c.name == "CharacterBody2D2":
			return false
			
		# Se uma empilhadeira com motorista ainda estiver aqui, não para o som
		if "esta_dirigindo" in c and c.esta_dirigindo:
			return false
			
	# Se varreu tudo e não achou ninguém, pode parar o som
	return true
