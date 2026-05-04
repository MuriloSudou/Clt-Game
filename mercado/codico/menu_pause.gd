extends CanvasLayer

# Pegando as referências exatas dos seus botões
@onready var btn_retornar = $Fundo/Retornar
@onready var btn_vmenu = $Fundo/Vmenu
@onready var btn_rlevel = $Fundo/Rlevel

func _ready():
	# O menu começa invisível
	visible = false
	
	# Prepara os 3 botões para a animação assim que o jogo abre
	configurar_animacao_botao(btn_retornar)
	configurar_animacao_botao(btn_vmenu)
	configurar_animacao_botao(btn_rlevel)

func configurar_animacao_botao(botao: Button):
	# 1. O SEGREDO: Muda o ponto de ancoragem para o CENTRO do botão.
	# Se não fizermos isso, o botão cresce torto (puxando para a direita e para baixo).
	botao.pivot_offset = botao.size / 2
	
	# 2. Conecta o sinal de "mouse entrou" e "mouse saiu" direto por código
	botao.mouse_entered.connect(animar_crescer.bind(botao))
	botao.mouse_exited.connect(animar_diminuir.bind(botao))

# --- ANIMAÇÕES (TWEENS) ---

func animar_crescer(botao: Button):
	# Cria o animador
	var tween = create_tween()
	# Anima a propriedade "scale" para 1.1 (10% maior) em 0.1 segundos
	tween.tween_property(botao, "scale", Vector2(1.1, 1.1), 0.1)

func animar_diminuir(botao: Button):
	var tween = create_tween()
	# Anima a propriedade "scale" de volta para 1.0 (tamanho original)
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
	alternar_pause()

func _on_rlevel_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_vmenu_pressed():
	get_tree().paused = false
	# IMPORTANTE: Confirme se o nome da cena do seu menu principal é este mesmo
	get_tree().change_scene_to_file("res://mercado/scenes/main_menu.tscn")
