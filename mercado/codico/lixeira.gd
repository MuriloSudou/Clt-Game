extends Area2D

# --- NÓS DE ÁUDIO ---
@onready var som_depositar = $SomDepositar
@onready var som_complet = $SomComplet     # NOVO: Segundo som de tarefa completa

# Variável de controle interna
var jogador_perto = false

# Função atualizada para tocar os dois sons ao mesmo tempo
func tocar_som():
	if som_depositar:
		som_depositar.play()
	if som_complet:
		som_complet.play() # NOVO: Toca o som de completo junto

# Escuta o teclado do jogador
func _input(event):
	if event.is_action_pressed("interagir") and jogador_perto:
		tocar_som()

# --- SINAIS ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		jogador_perto = true
		body.lixeira_perto = self
		print("Jogador na zona da lixeira.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		jogador_perto = false
		if body.lixeira_perto == self:
			body.lixeira_perto = null
			print("Jogador saiu da zona da lixeira.")
