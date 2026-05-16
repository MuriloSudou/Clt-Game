extends Control

# --- NÓS DE ÁUDIO ---
@onready var som_hover = $SomHover
@onready var som_clique = $SomClique 

func _ready() -> void:
	# Conecta o efeito hover no botão Industria
	$Industria.mouse_entered.connect(_on_hover_enter.bind($Industria))
	$Industria.mouse_exited.connect(_on_hover_exit.bind($Industria))
	
	# Conecta o efeito hover no botão Mercado
	$Mercado.mouse_entered.connect(_on_hover_enter.bind($Mercado))
	$Mercado.mouse_exited.connect(_on_hover_exit.bind($Mercado))

	# Conecta o efeito hover no botão Escritorio
	$Escritorio.mouse_entered.connect(_on_hover_enter.bind($Escritorio))
	$Escritorio.mouse_exited.connect(_on_hover_exit.bind($Escritorio))

func _on_jogar_pressed() -> void:
	som_clique.play()                 # Toca o clique
	await som_clique.finished         # Espera o som terminar
	get_tree().change_scene_to_file("res://industria/mundo.tscn")

func _on_sair_pressed() -> void:
	som_clique.play()                 # Toca o clique
	await som_clique.finished         # Espera o som terminar
	get_tree().change_scene_to_file("res://mercado/scenes/Trabalhador.tscn")

func _on_escritorio_pressed() -> void:
	som_clique.play()                 # Toca o clique
	await som_clique.finished         # Espera o som terminar
	get_tree().change_scene_to_file("res://mercado/scenes/escritorio.tscn")


func _on_hover_enter(botao: Button) -> void:
	botao.pivot_offset = botao.size / 2
	create_tween().tween_property(botao, "scale", Vector2(1.15, 1.15), 0.15)
	
	# Toca o som de hover (já funciona em TODOS os botões que entram aqui)
	som_hover.play()

func _on_hover_exit(botao: Button) -> void:
	create_tween().tween_property(botao, "scale", Vector2(1.0, 1.0), 0.15)
