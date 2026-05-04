extends Area2D

@onready var corpo_solido = $CorpoSolido
# Pega as referências dos nós de áudio
@onready var som_pegar = $SomPegar
@onready var som_soltar = $SomSoltar

# --- FUNÇÕES DE ÁUDIO ---
func tocar_som_pegar():
	if som_pegar:
		som_pegar.play()

func tocar_som_soltar():
	if som_soltar:
		som_soltar.play()
# --- REFERÊNCIAS ---
# Captura o CollisionShape que serve de barreira física (aquele dentro de CorpoSolido)
@onready var colisao_fisica = get_node_or_null("CorpoSolido/CollisionShape2D")

# --- FUNÇÕES PARA O PERSONAGEM CHAMAR ---
# Estas funções controlam se o lixo é sólido ou não.

func desativar_fisica():
	# Desativa a colisão física ao pegar
	if colisao_fisica:
		colisao_fisica.set_deferred("disabled", true)
		print("Lixo: Física DESLIGADA")
	else:
		print("Lixo: Erro! Não encontrei o nó CorpoSolido/CollisionShape2D")

func ativar_fisica():
	# Ativa a colisão física ao soltar no chão
	if colisao_fisica:
		colisao_fisica.set_deferred("disabled", false)
		print("Lixo: Física LIGADA")
	else:
		print("Lixo: Erro! Não encontrei o nó CorpoSolido/CollisionShape2D")

# --- FUNÇÕES DE SINAL (A Detecção) ---
# Estas funções dizem ao jogador que o lixo está por perto.

func _on_body_entered(body: Node2D) -> void:
	# Confere se foi o seu personagem da print (CharacterBody2D2)
	if body.name == "CharacterBody2D2":
		# Avisa o personagem: "Eu sou o lixo que está perto, você pode me pegar!"
		body.lixo_perto = self
		print("Jogador entrou na área do lixo.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D2":
		# Se o jogador se afastar e este ainda for o lixo que estava perto, limpamos a variável
		if body.lixo_perto == self:
			body.lixo_perto = null
			print("Jogador saiu da área do lixo.")
