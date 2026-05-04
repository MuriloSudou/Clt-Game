extends RigidBody2D

var jogador_perto = null

@onready var sprite = $Sprite2D
@onready var sensor = $Sensor 

func _ready() -> void:
	# Conectando os sinais do Sensor via código
	sensor.body_entered.connect(_on_body_entered)
	sensor.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador":
		jogador_perto = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Jogador":
		jogador_perto = null

func _process(_delta: float) -> void:
	# Se o jogador estiver perto e apertar a tecla 'E' que criamos
	if jogador_perto and Input.is_action_just_pressed("interagir"):
		
		# Verifica se o jogador tem a função de pegar item
		if jogador_perto.has_method("pegar_item"):
			jogador_perto.pegar_item(sprite.texture) # Manda o desenho da caixa
			queue_free() # Destrói a caixa do chão
