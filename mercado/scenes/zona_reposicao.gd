extends Area2D

@onready var label_aviso = $Label
@onready var barra_progresso = $ProgressBar
@onready var seta = $Seta # Pega a nossa nova seta

# NOVO: Referência para o som de tarefa concluída
@onready var som_concluido = $SomConcluido

var jogador_perto = false
var progresso = 0.0
var velocidade_reposicao = 40.0
var ja_reposto = false

# Variável para guardar a altura inicial da seta para a animação
var pos_y_original_seta = 0.0

func _ready():
	# Começa configurando o que aparece e o que esconde
	label_aviso.visible = false
	barra_progresso.visible = false
	barra_progresso.value = 0
	seta.visible = true # Seta começa visível de longe
	
	# Pega a posição original e começa a animação de flutuar
	if seta:
		pos_y_original_seta = seta.position.y
		animar_seta()

# --- ANIMAÇÃO DA SETA FLUTUANDO ---
func animar_seta():
	if not seta: return
	var tween = create_tween().set_loops() # Cria um loop infinito
	# A seta desce 10 pixels de forma suave
	tween.tween_property(seta, "position:y", pos_y_original_seta + 10, 0.5).set_trans(Tween.TRANS_SINE)
	# A seta sobe de volta para a posição original
	tween.tween_property(seta, "position:y", pos_y_original_seta, 0.5).set_trans(Tween.TRANS_SINE)


# --- LÓGICA DO JOGO ---
func _process(delta):
	if ja_reposto or not jogador_perto:
		return
		
	if Input.is_action_pressed("interagir"):
		# Enquanto segura o botão
		label_aviso.visible = false
		seta.visible = false
		barra_progresso.visible = true
		
		progresso += velocidade_reposicao * delta
		barra_progresso.value = progresso
		
		if progresso >= 100.0:
			concluir_reposicao()
	else:
		# Se soltar antes do fim
		if barra_progresso.visible:
			barra_progresso.visible = false
			label_aviso.visible = true
			progresso = 0.0
			barra_progresso.value = 0

func concluir_reposicao():
	ja_reposto = true
	barra_progresso.visible = false
	label_aviso.visible = false
	if seta:
		seta.visible = false
	
	# NOVO: Toca o som de sucesso imediatamente
	som_concluido.play()
	
	# get_tree().current_scene pega a raiz do mapa atual com 100% de certeza
	get_tree().current_scene.registrar_reposicao()
	
	print("Gôndola reposta com sucesso!")

# --- SINAIS DE DETECÇÃO ---

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D2" and not ja_reposto:
		jogador_perto = true
		label_aviso.visible = true
		seta.visible = false # Chegou perto? Esconde a seta e mostra o texto

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		jogador_perto = false
		label_aviso.visible = false
		barra_progresso.visible = false
		progresso = 0.0
		barra_progresso.value = 0
		
		# Saiu de perto e ainda não repôs? Mostra a seta de novo
		if not ja_reposto:
			seta.visible = true
