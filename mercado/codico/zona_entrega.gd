extends Area2D

var total_pallets = 0
var missao_concluida = false 

@onready var label_contador = get_tree().current_scene.find_child("TextoVitoria", true, false)
@onready var label_centro = get_tree().current_scene.find_child("TextoIntro", true, false)

# --- NOVOS NÓS DE ÁUDIO ---
@onready var som_entrega = $SomEntrega
@onready var som_vitoria = $SomVitoria


func _ready():

	body_entered.connect(_ao_entrar_na_zona)
	body_exited.connect(_ao_sair_na_zona)

	if label_contador:
		label_contador.text = "Pallets: 0 / 6"


func _ao_entrar_na_zona(body):

	if body.is_in_group("pallets"):

		total_pallets += 1

		# TOCA SOM
		som_entrega.play()

		atualizar_tela()


func _ao_sair_na_zona(body):

	if body.is_in_group("pallets"):

		total_pallets -= 1

		if total_pallets < 6:
			missao_concluida = false

		atualizar_tela()


func atualizar_tela():

	if label_contador:

		# AINDA NÃO TERMINOU
		if total_pallets < 6:

			label_contador.text = "Pallets: " + str(total_pallets) + " / 6"

			label_contador.add_theme_color_override("font_color", Color.WHITE)

		# TODOS OS PALLETS CONCLUÍDOS
		else:

			label_contador.text = "Pallets: 6 / 6"

			label_contador.add_theme_color_override("font_color", Color.GREEN)

			if not missao_concluida and label_centro:

				missao_concluida = true

				# AVISA O SCRIPT PRINCIPAL
				get_tree().current_scene.concluir_pallets()

				# MOSTRA MENSAGEM
				mostrar_vitoria_no_centro()


func mostrar_vitoria_no_centro():

	# SOM DE VITÓRIA
	som_vitoria.play()

	# PARA O CRONÔMETRO
	var timer_node = get_tree().current_scene.find_child("TextoTimer", true, false)

	if timer_node:
		timer_node.parar()

	# TEXTO CENTRAL
	label_centro.text = "MISSÃO CUMPRIDA!\nAGORA HORA DE ORGANIZAR O SUPERMERCADO!"

	label_centro.add_theme_color_override("font_color", Color.GREEN)

	label_centro.visible = true

	label_centro.modulate.a = 0.0

	# FADE IN
	var tween_aparecer = create_tween()

	tween_aparecer.tween_property(label_centro, "modulate:a", 1.0, 1.0)

	# ESPERA
	await get_tree().create_timer(5.0).timeout

	# FADE OUT
	if total_pallets >= 6:

		var tween_sumir = create_tween()

		tween_sumir.tween_property(label_centro, "modulate:a", 0.0, 2.0)

		if timer_node:
			tween_sumir.parallel().tween_property(timer_node, "modulate:a", 0.0, 2.0)

		await tween_sumir.finished

		label_centro.visible = false

		if timer_node:
			timer_node.visible = false
