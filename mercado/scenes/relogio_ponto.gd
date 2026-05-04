extends Area2D

var jogador_perto = false
var turno_iniciado = false

# Puxa aquele texto bonitão do meio da tela que criamos
@onready var label_centro = get_tree().current_scene.find_child("TextoIntro", true, false)

func _ready():
	# Conecta os sensores de presença
	body_entered.connect(_ao_entrar_na_area)
	body_exited.connect(_ao_sair_na_area)

func _ao_entrar_na_area(body):
	if body.name == "CharacterBody2D2": # Nome do seu boneco
		jogador_perto = true
		print("Perto do relógio. Pressione a tecla de interagir para bater o ponto.")

func _ao_sair_na_area(body):
	if body.name == "CharacterBody2D2":
		jogador_perto = false

# Lê o teclado do jogador
func _input(event):
	# Se apertar o botão de interagir (E), estiver perto e ainda não tiver batido o ponto...
	if event.is_action_pressed("interagir") and jogador_perto and not turno_iniciado:
		bater_o_ponto()

func bater_o_ponto():
	turno_iniciado = true
	
	# --- NOVO: FAZ O INDICADOR SUMIR ---
	if has_node("Indicador"):
		get_node("Indicador").visible = false
	# ----------------------------------

	
	
	# Procura o timer no HUD e ativa
	var timer_node = get_tree().current_scene.find_child("TextoTimer", true, false)
	if timer_node:
		timer_node.set_process(true)
		timer_node.visible = true
	
	# Mostra a mensagem no centro
	if label_centro:
		label_centro.text = "TURNO INICIADO!\nOrganize os 6 pallets."
		label_centro.visible = true
		
		var tween_aparecer = create_tween()
		tween_aparecer.tween_property(label_centro, "modulate:a", 1.0, 0.5)
		
		await get_tree().create_timer(4.0).timeout
		
		var tween_sumir = create_tween()
		tween_sumir.tween_property(label_centro, "modulate:a", 0.0, 1.5)
		await tween_sumir.finished
		label_centro.visible = false
	
	# Faz a mágica do texto aparecer no meio da tela
	if label_centro:
		label_centro.text = "TURNO INICIADO!\nOrganize os 6 pallets."
		label_centro.add_theme_color_override("font_color", Color("FFD700")) # Amarelo Ouro
		label_centro.visible = true
		
		# Animação de Fade In
		var tween_aparecer = create_tween()
		tween_aparecer.tween_property(label_centro, "modulate:a", 1.0, 0.5)
		
		# Deixa na tela por 4 segundos
		await get_tree().create_timer(4.0).timeout
		
		# Animação de Fade Out
		var tween_sumir = create_tween()
		tween_sumir.tween_property(label_centro, "modulate:a", 0.0, 1.5)
		await tween_sumir.finished
		
		label_centro.visible = false
