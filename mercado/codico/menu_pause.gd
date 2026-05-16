extends CanvasLayer

# Pegando as referências exatas dos seus botões
@onready var btn_retornar = $Fundo/Retornar
@onready var btn_vmenu = $Fundo/Vmenu
@onready var btn_rlevel = $Fundo/Rlevel

# --- NÓS DE ÁUDIO ---
@onready var som_hover = $SomHover
@onready var som_clique = $SomClique

func _ready():
	# O menu começa invisível
	visible = false
	
	# Prepara os 3 botões para a animação assim que o jogo abre
	configurar_animacao_botao(btn_retornar)
	configurar_animacao_botao(btn_vmenu)
	configurar_animacao_botao(btn_rlevel)

func configurar_animacao_botao(botao: Button):
	# 1. O SEGREDO: Muda o ponto de ancoragem para o CENTRO do botão.
	botao.pivot_offset = botao.size / 2
	
	# 2. Conecta o sinal de "mouse entrou" e "mouse saiu" direto por código
	botao.mouse_entered.connect(animar_crescer.bind(botao))
	botao.mouse_exited.connect(animar_diminuir.bind(botao))

# --- ANIMAÇÕES (TWEENS) ---

func animar_crescer(botao: Button):
	var tween = create_tween()
	tween.tween_property(botao, "scale", Vector2(1.1, 1.1), 0.1)
	
	# Toca o som de hover ao passar o mouse
	som_hover.play()

func animar_diminuir(botao: Button):
	var tween = create_tween()
	tween.tween_property(botao, "scale", Vector2(1.0, 1.0), 0.1)


# --- SISTEMA DE PAUSE ---

func _input(event):
	if event.is_action_pressed("pause"):
		alternar_pause()

func alternar_pause():
	var esta_pausado = get_tree().paused
	get_tree().paused = !esta_pausado
	visible = !esta_pausado

# --- FUNÇÕES DE CLIQUE DOS BOTÕES ---

func _on_retornar_pressed():
	som_clique.play() # Toca o clique (não precisa de await porque a cena não vai sumir)
	alternar_pause()

func _on_rlevel_pressed():
	som_clique.play()
	await som_clique.finished # Espera o som terminar antes de reiniciar a fase
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_vmenu_pressed():
	som_clique.play()
	await som_clique.finished # Espera o som terminar antes de ir para o menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mercado/scenes/main_menu.tscn")
