extends Control

func _ready() -> void:
	# Conecta o efeito hover no botão Industria
	$Industria.mouse_entered.connect(_on_hover_enter.bind($Industria))
	$Industria.mouse_exited.connect(_on_hover_exit.bind($Industria))
	
	# Conecta o efeito hover no botão Sair
	$Mercado.mouse_entered.connect(_on_hover_enter.bind($Mercado))
	$Mercado.mouse_exited.connect(_on_hover_exit.bind($Mercado))

	# Conecta o efeito hover no botão Sair
	$Escritorio.mouse_entered.connect(_on_hover_enter.bind($Escritorio))
	$Escritorio.mouse_exited.connect(_on_hover_exit.bind($Escritorio))

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://industria/mundo.tscn")

func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://mercado/scenes/Trabalhador.tscn")

func _on_escritorio_pressed() -> void:
	get_tree().change_scene_to_file("res://mercado/scenes/escritorio.tscn")


func _on_hover_enter(botao: Button) -> void:
	botao.pivot_offset = botao.size / 2
	create_tween().tween_property(botao, "scale", Vector2(1.15, 1.15), 0.15)

func _on_hover_exit(botao: Button) -> void:
	create_tween().tween_property(botao, "scale", Vector2(1.0, 1.0), 0.15)
