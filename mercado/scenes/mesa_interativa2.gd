extends Area2D

# Puxa o nó de texto e a seta que criamos
@onready var aviso_texto = $Label
@onready var seta = $Seta 

# O @export cria um campo no Inspector para você digitar o caminho da tela!
@export var cena_destino: String = "res://newminigame/scenes/Main.tscn"

var jogador_perto = false

# --- DETALHE QUE FALTAVA 1: Declarar a variável da posição original ---
var pos_y_original_seta = 0.0

func _ready():
	# Garante que o texto comece invisível e a seta visível
	aviso_texto.visible = false
	
	if seta:
		seta.visible = true
		# --- DETALHE QUE FALTAVA 2: Salvar a posição e rodar a animação ---
		pos_y_original_seta = seta.position.y
		animar_seta()

func _process(_delta):
	# Se o jogador estiver na área E apertar o botão de interação
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		# Muda para a tela que você configurou no Inspector
		get_tree().change_scene_to_file(cena_destino)

# --- ANIMAÇÃO DA SETA FLUTUANDO ---
func animar_seta():
	if not seta: return
	var tween = create_tween().set_loops() # Cria um loop infinito
	# A seta desce 10 pixels de forma suave
	tween.tween_property(seta, "position:y", pos_y_original_seta + 10, 0.5).set_trans(Tween.TRANS_SINE)
	# A seta sobe de volta para a posição original
	tween.tween_property(seta, "position:y", pos_y_original_seta, 0.5).set_trans(Tween.TRANS_SINE)

# --- SINAIS DE DETECÇÃO ---

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D3":
		jogador_perto = true
		aviso_texto.visible = true # Mostra o "Aperte E"
		if seta:
			seta.visible = false # Esconde a seta quando chega perto

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D3":
		jogador_perto = false
		aviso_texto.visible = false # Esconde o "Aperte E"
		if seta:
			seta.visible = true # Mostra a seta de novo quando vai embora
