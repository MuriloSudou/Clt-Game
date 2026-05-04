extends CharacterBody2D

@export var velocidade: float = 60.0
@export var pontos: Array[Node2D] = []

var destino: Vector2 = Vector2.ZERO
var esperando: bool = false
var ultimo_ponto: Node2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	randomize()
	escolher_novo_destino()

func _physics_process(_delta: float) -> void:
	if esperando:
		velocity = Vector2.ZERO
		move_and_slide()
		atualizar_animacao(Vector2.ZERO)
		return

	var direcao: Vector2 = destino - global_position

	if direcao.length() < 5.0:
		chegou_no_destino()
		return

	direcao = direcao.normalized()
	velocity = direcao * velocidade

	move_and_slide()
	atualizar_animacao(velocity)

func escolher_novo_destino() -> void:
	if pontos.is_empty():
		return

	var opcoes: Array[Node2D] = []

	for ponto in pontos:
		if ponto != null and ponto != ultimo_ponto:
			opcoes.append(ponto)

	if opcoes.is_empty():
		opcoes = pontos.duplicate()

	var ponto_escolhido: Node2D = opcoes.pick_random()
	ultimo_ponto = ponto_escolhido
	destino = ponto_escolhido.global_position

func chegou_no_destino() -> void:
	if esperando:
		return

	esperando = true
	velocity = Vector2.ZERO
	atualizar_animacao(Vector2.ZERO)

	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

	esperando = false
	escolher_novo_destino()

func atualizar_animacao(direcao: Vector2) -> void:
	if direcao.length() < 1.0:
		anim.stop()
		return

	if abs(direcao.x) > abs(direcao.y):
		anim.play("direita")
		anim.flip_h = direcao.x < 0
	else:
		anim.play("frente")
		anim.flip_h = false
