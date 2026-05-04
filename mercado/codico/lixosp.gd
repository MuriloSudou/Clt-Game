extends Node2D

# ==========================================
# REFERÊNCIAS DE TELA E ÁUDIO
# ==========================================
@onready var texto_pontuacao = $CanvasLayer2/TextoPontuacao
@onready var texto_gondolas = $CanvasLayer2/TextoGondolas # <-- Referência do novo texto!
@onready var musica_vitoria = $MusicaVitoria

# ==========================================
# VARIÁVEIS DOS LIXOS
# ==========================================
var total_lixos = 0
var lixos_recolhidos = 0

# ==========================================
# VARIÁVEIS DAS GÔNDOLAS
# ==========================================
var total_gondolas = 0
var gondolas_repostas = 0


func _ready():
	# 1. Configura a contagem de Lixos
	total_lixos = get_tree().get_nodes_in_group("lixos").size()
	atualizar_interface_lixos()
	
	# 2. Configura a contagem de Gôndolas
	total_gondolas = get_tree().get_nodes_in_group("gondolas").size()
	atualizar_interface_gondolas()


# ==========================================
# MÉTODOS DO LIXO
# ==========================================
func atualizar_interface_lixos():
	# Verifica se o nó existe antes de mudar o texto (evita erros nulos)
	if texto_pontuacao:
		texto_pontuacao.text = "Lixos Limpos: " + str(lixos_recolhidos) + " / " + str(total_lixos)

func registrar_lixo_depositado():
	lixos_recolhidos += 1
	atualizar_interface_lixos()
	
	# Verifica se pegou todos os lixos
	if lixos_recolhidos == total_lixos:
		tocar_vitoria()


# ==========================================
# MÉTODOS DAS GÔNDOLAS
# ==========================================
func atualizar_interface_gondolas():
	if texto_gondolas:
		texto_gondolas.text = "Repor: " + str(gondolas_repostas) + " / " + str(total_gondolas)

func registrar_reposicao():
	gondolas_repostas += 1
	atualizar_interface_gondolas()
	
	# Verifica se repôs todas as gôndolas
	if gondolas_repostas == total_gondolas:
		print("Todas as gôndolas foram repostas!")
		# Opcional: Se quiser que toque a música de vitória quando terminar de repor,
		# basta tirar o '#' da linha de baixo:
		# tocar_vitoria()


# ==========================================
# MÉTODOS GERAIS
# ==========================================
func tocar_vitoria():
	print("Música de vitória tocando!")
	musica_vitoria.play()
	# Aqui no futuro você pode chamar uma tela de "Fase Concluída"!
