extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var area_interacao = $AreaInteracao
var jogador_perto = null

func _ready():
	
	add_to_group("caixas")
	
	# Conecta o sensor invisível ao código
	area_interacao.body_entered.connect(_on_body_entered)
	area_interacao.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Jogador":
		jogador_perto = body

func _on_body_exited(body):
	if body.name == "Jogador":
		jogador_perto = null

func _process(_delta):
	# Se o jogador estiver na área e apertar 'E' (interagir)
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		if jogador_perto.has_method("pegar_item"):
			jogador_perto.pegar_item(sprite.texture)
			queue_free() # Destrói a caixa do chão
