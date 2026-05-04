extends CharacterBody2D

@export var velocidade: float = 100.0
var direcao: Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var som_choque = $SomChoque


func _ready():
	# randomize() é vital! Sem isso, o aleatório do Godot é sempre igual toda vez que você abre o jogo
	randomize() 
	escolher_nova_direcao()

func _physics_process(_delta):
	# Define a velocidade multiplicando a direção sorteada pela velocidade
	velocity = direcao * velocidade
	
	# O move_and_slide faz ele andar e respeitar paredes automaticamente!
	move_and_slide()
	
	# Se ele bater de cara em uma parede...
	if is_on_wall():
		escolher_nova_direcao()
		efeito_de_choque() # <--- CHAMA O EFEITO AQUI!
	
	# Se ele bater de cara em uma parede antes do Timer acabar, ele escolhe outro caminho
	if is_on_wall():
		escolher_nova_direcao()
		
	# A mesma lógica de antes para virar o rostinho dele para o lado certo
	if direcao.x < 0:
		sprite.flip_h = true
	elif direcao.x > 0:
		sprite.flip_h = false

# Função personalizada para sortear para onde ele vai
func escolher_nova_direcao():
	# Sorteia um número entre -1 e 1 para X (Esquerda/Direita) e Y (Cima/Baixo)
	var x_aleatorio = randf_range(-1.0, 1.0)
	var y_aleatorio = randf_range(-1.0, 1.0)
	
	# O .normalized() garante que ele não ande mais rápido na diagonal!
	direcao = Vector2(x_aleatorio, y_aleatorio).normalized()

# Quando o reloginho apitar (a cada 2 ou 3 segundos), sorteia de novo
func _on_timer_direcao_timeout():
	escolher_nova_direcao()

# O mesmo Game Over do outro inimigo!
func _on_sensor_jogador_body_entered(body):
	if body.name == "Jogador":
		if body.has_method("tomar_dano"):
			body.tomar_dano()
			
			
func efeito_de_choque():
	som_choque.play() # Toca o bzz!
	sprite.modulate = Color(0.039, 0.51, 0.98, 0.639) 
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)
