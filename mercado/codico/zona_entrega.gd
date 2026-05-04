extends Area2D

var total_pallets = 0
var missao_concluida = false 

@onready var label_contador = get_tree().current_scene.find_child("TextoVitoria", true, false)
@onready var label_centro = get_tree().current_scene.find_child("TextoIntro", true, false)

func _ready():
	body_entered.connect(_ao_entrar_na_zona)
	body_exited.connect(_ao_sair_na_zona)
	
	if label_contador:
		label_contador.text = "Pallets: 0 / 6"

func _ao_entrar_na_zona(body):
	if body.is_in_group("pallets"):
		total_pallets += 1
		atualizar_tela()

func _ao_sair_na_zona(body):
	if body.is_in_group("pallets"):
		total_pallets -= 1
		if total_pallets < 6:
			missao_concluida = false
		atualizar_tela()

func atualizar_tela():
	if label_contador:
		# --- AINDA NÃO ACABOU ---
		if total_pallets < 6:
			label_contador.text = "Pallets: " + str(total_pallets) + " / 6"
			label_contador.add_theme_color_override("font_color", Color.WHITE)
		
		# --- VITÓRIA ---
		else:
			label_contador.text = "Pallets: 6 / 6"
			label_contador.add_theme_color_override("font_color", Color.GREEN)
			
			if not missao_concluida and label_centro:
				missao_concluida = true
				mostrar_vitoria_no_centro()

func mostrar_vitoria_no_centro():
	# 1. PARA O CRONÔMETRO
	var timer_node = get_tree().current_scene.find_child("TextoTimer", true, false)
	if timer_node:
		timer_node.parar()
		
	# 2. MOSTRA A MENSAGEM
	label_centro.text = "MISSÃO CUMPRIDA!\nAGORA HORA DE ORGANIZAR O SUPERMERCADO!"
	label_centro.add_theme_color_override("font_color", Color.GREEN) 
	label_centro.visible = true
	
	var tween_aparecer = create_tween()
	tween_aparecer.tween_property(label_centro, "modulate:a", 1.0, 1.0)
	
	# Fica na tela por 5 segundos para o jogador ver o tempo final dele
	await get_tree().create_timer(5.0).timeout
	
	if total_pallets >= 6:
		var tween_sumir = create_tween()
		# Faz a mensagem central sumir
		tween_sumir.tween_property(label_centro, "modulate:a", 0.0, 2.0)
		
		# Faz o cronômetro sumir ao mesmo tempo (usando parallel)
		if timer_node:
			tween_sumir.parallel().tween_property(timer_node, "modulate:a", 0.0, 2.0)
			
		await tween_sumir.finished
		
		# Desliga a visibilidade dos dois para não gastar processamento
		label_centro.visible = false
		if timer_node:
			timer_node.visible = false
