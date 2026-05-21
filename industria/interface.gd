extends CanvasLayer

var pontos = 0
# Defina aqui quantas caixas o jogador precisa entregar para ganhar!
var pontos_para_vencer = 7

@onready var texto_pontos = $TextoPontos
@onready var texto_tempo = $TextoTempo
@onready var texto_vida = $TextoVida # Aqui está o seu Label de vida!
@onready var timer = $TempoFase
@onready var musica_vitoria= $MusicaVitoria
@onready var texto_fim_de_jogo = $TextoFimDeJogo
@onready var texto_vitoria = $TextoVitoria
@onready var musica_fim = $MusicaFim
@onready var botao_reiniciar = $BotaoReiniciar 

func _process(_delta):
	# Atualiza o relógio
	if timer.time_left > 0:
		texto_tempo.text = "Tempo: " + str(int(timer.time_left))

# Atualiza o texto das vidas na tela
func atualizar_vida(nova_vida):
	texto_vida.text = "Vidas: " + str(nova_vida)

func adicionar_ponto():
	pontos += 1
	texto_pontos.text = "Caixas: " + str(pontos)
	
	# Verifica se alcançou a meta de vitória!
	if pontos >= pontos_para_vencer:
		mostrar_vitoria()

func mostrar_vitoria():
	texto_vitoria.visible = true 
	musica_vitoria.play()
	botao_reiniciar.visible = true
	
	get_tree().paused = true

func mostrar_game_over():
	# Torna o seu Label próprio visível!
	texto_fim_de_jogo.visible = true 
	
	botao_reiniciar.visible = true
	musica_fim.play()
	get_tree().paused = true

func _on_tempo_fase_timeout():
	mostrar_game_over()

# A função do nosso botão de jogar novamente
func _on_botao_reiniciar_pressed():
	# Despausa o jogo antes de recarregar a cena!
	get_tree().paused = false 
	get_tree().reload_current_scene()

func perder_tempo(segundos_perdidos):
	# Calcula quanto tempo vai sobrar
	var novo_tempo = timer.time_left - segundos_perdidos
	
	if novo_tempo > 0:
		# Reinicia o relógio com o tempo descontado
		timer.start(novo_tempo)
		
		# Faz o texto do tempo piscar de vermelho para o jogador notar!
		texto_tempo.modulate = Color(1, 0, 0)
		var tween = create_tween()
		tween.tween_property(texto_tempo, "modulate", Color(1, 1, 1), 0.3)
	else:
		# Se o tempo zerou no roubo, Game Over na hora
		timer.stop()
		mostrar_game_over()
func ganhar_tempo(segundos_ganhos):
	# Soma o tempo que sobrou com o bônus
	var novo_tempo = timer.time_left + segundos_ganhos
	
	# Reinicia o relógio com o tempo extra
	timer.start(novo_tempo)
	
	# Faz o texto do tempo piscar em VERDE para dar um feedback positivo!
	texto_tempo.modulate = Color(0, 1, 0) 
	var tween = create_tween()
	tween.tween_property(texto_tempo, "modulate", Color(1, 1, 1), 0.3)
