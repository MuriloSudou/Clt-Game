extends Area2D

# Pega a referência do nó de som
@onready var som_depositar = $SomDepositar

# Nova função para tocar o som
func tocar_som():
	if som_depositar:
		som_depositar.play()

# --- SINAIS (Mantenha os seus aqui embaixo) ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		body.lixeira_perto = self
		print("Jogador na zona da lixeira.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		if body.lixeira_perto == self:
			body.lixeira_perto = null
			print("Jogador saiu da zona da lixeira.")
