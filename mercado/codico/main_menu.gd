extends Control

func _ready() -> void:
	# Conecta o efeito hover no botão Jogar
	$Jogar.mouse_entered.connect(_on_hover_enter.bind($Jogar))
	$Jogar.mouse_exited.connect(_on_hover_exit.bind($Jogar))
	
	# Conecta o efeito hover no botão Sair
	$Sair.mouse_entered.connect(_on_hover_enter.bind($Sair))
	$Sair.mouse_exited.connect(_on_hover_exit.bind($Sair))
	
	$Atestado.mouse_entered.connect(_on_hover_enter.bind($Atestado))
	$Atestado.mouse_exited.connect(_on_hover_exit.bind($Atestado))
	

func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://mercado/scenes/selecionarTrabalho.tscn")

func _on_sair_pressed() -> void:
	$SairDialog.dialog_text = "Tem certeza que quer Pedir A Conta?"
	$SairDialog.popup_centered()
	
func _on_sair_dialog_confirmed() -> void:
	OS.shell_open("https://g1.globo.com/jornal-nacional/noticia/2025/09/27/falta-de-trabalhadores-no-comercio-e-a-maior-dos-ultimos-5-anos-diz-setor.ghtml")
	get_tree().quit()
	
	

func _on_hover_enter(botao: Button) -> void:
	botao.pivot_offset = botao.size / 2
	create_tween().tween_property(botao, "scale", Vector2(1.15, 1.15), 0.15)

func _on_hover_exit(botao: Button) -> void:
	create_tween().tween_property(botao, "scale", Vector2(1.0, 1.0), 0.15)

func _on_atestado_pressed() -> void:
	$AtestadoDialog.dialog_text = "Infelizmente o Atestado esta indisponível, vai trabalhar!"
	$AtestadoDialog.popup_centered()
	
