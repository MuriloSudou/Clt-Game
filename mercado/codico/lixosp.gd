extends Node2D

# ==========================================
# REFERÊNCIAS DE TELA E ÁUDIO
# ==========================================
@onready var texto_pontuacao = $CanvasLayer2/TextoPontuacao
@onready var texto_gondolas = $CanvasLayer2/TextoGondolas
@onready var musica_vitoria = $MusicaVitoria

# PAINEL FINAL
@onready var painel_fim = $CanvasLayer3/PainelFim
@onready var label_titulo = $CanvasLayer3/PainelFim/LabelTitulo
@onready var label_texto = $CanvasLayer3/PainelFim/LabelTexto

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

# ==========================================
# VARIÁVEL DOS PALLETS
# ==========================================
var pallets_concluidos = false


# ==========================================
# READY
# ==========================================
func _ready():

	# ESCONDE O PAINEL FINAL
	painel_fim.visible = false

	# CONFIGURA LIXOS
	total_lixos = get_tree().get_nodes_in_group("lixos").size()
	atualizar_interface_lixos()

	# CONFIGURA GÔNDOLAS
	total_gondolas = get_tree().get_nodes_in_group("gondolas").size()
	atualizar_interface_gondolas()


# ==========================================
# INTERFACE DOS LIXOS
# ==========================================
func atualizar_interface_lixos():

	if texto_pontuacao:
		texto_pontuacao.text = "Lixos Limpos: " + str(lixos_recolhidos) + " / " + str(total_lixos)


# ==========================================
# REGISTRA LIXO
# ==========================================
func registrar_lixo_depositado():

	lixos_recolhidos += 1

	atualizar_interface_lixos()

	verificar_objetivos()


# ==========================================
# INTERFACE DAS GÔNDOLAS
# ==========================================
func atualizar_interface_gondolas():

	if texto_gondolas:
		texto_gondolas.text = "Repor: " + str(gondolas_repostas) + " / " + str(total_gondolas)


# ==========================================
# REGISTRA REPOSIÇÃO
# ==========================================
func registrar_reposicao():

	gondolas_repostas += 1

	atualizar_interface_gondolas()

	verificar_objetivos()


# ==========================================
# CHAME ESSA FUNÇÃO QUANDO TERMINAR OS PALLETS
# ==========================================
func concluir_pallets():

	pallets_concluidos = true

	verificar_objetivos()


# ==========================================
# VERIFICA OBJETIVOS
# ==========================================
func verificar_objetivos():

	print("Lixos:", lixos_recolhidos, "/", total_lixos)
	print("Reposição:", gondolas_repostas, "/", total_gondolas)
	print("Pallets:", pallets_concluidos)

	if lixos_recolhidos >= total_lixos \
	and gondolas_repostas >= total_gondolas \
	and pallets_concluidos == true:

		print("TODAS AS TAREFAS CONCLUÍDAS")

		mostrar_fim_expediente()

# ==========================================
# MOSTRA FIM DO EXPEDIENTE
# ==========================================
func mostrar_fim_expediente():

	painel_fim.visible = true

	label_titulo.text = "EXPEDIENTE FINALIZADO"

	label_texto.text = "✓ Pallets organizados\n" + \
	"✓ Lixos recolhidos\n" + \
	"✓ Produtos repostos\n\n" + \
	"Você sobreviveu a mais um dia de CLT."

	tocar_vitoria()

	await get_tree().create_timer(5.0).timeout

	painel_fim.visible = false


# ==========================================
# SOM DE VITÓRIA
# ==========================================
func tocar_vitoria():

	print("Música de vitória tocando!")

	if musica_vitoria:
		musica_vitoria.play()
