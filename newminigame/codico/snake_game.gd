extends Node2D

@onready var snake_node = $Snake
@onready var food = $Food
@onready var timer = $Timer
@onready var score_label = $ScoreLabel
@onready var game_over_label = $GameOverLabel
@onready var eat_sound = $EatSound

var grid_size = 20
var direction = Vector2.RIGHT

var snake_body = [Vector2(10, 10)]
var grow = false
var score = 0
var food_position = Vector2.ZERO

# 🔥 NOVO: tamanho dinâmico do grid
var grid_width
var grid_height


func _ready():
	randomize()

	# 🔥 PEGA O TAMANHO DA TELA DO MONITOR (Screen)
	var screen_size = get_parent().size
	
	grid_width = int(screen_size.x / grid_size)
	grid_height = int(screen_size.y / grid_size)

	spawn_food()
	draw_snake()


func _process(delta):
	# ❗ não processa se estiver escondido
	if not visible:
		return
		
	handle_input()


func handle_input():
	if Input.is_action_just_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT


func _on_timer_timeout():
	if not visible:
		return
		
	move_snake()


func move_snake():
	var new_head = snake_body[0] + direction

	# 💀 colisão com parede (AGORA DINÂMICO)
	if new_head.x < 0 or new_head.y < 0 or new_head.x >= grid_width or new_head.y >= grid_height:
		game_over()
		return

	# 💀 colisão com o corpo
	if new_head in snake_body:
		game_over()
		return

	snake_body.insert(0, new_head)

	# 🍎 comeu comida
	if new_head == food_position:
		grow = true
		score += 1
	
		eat_sound.play()
	
		score_label.text = "Score: " + str(score)
		spawn_food()

	if not grow:
		snake_body.pop_back()
	else:
		grow = false

	draw_snake()


func draw_snake():
	# limpa
	for child in snake_node.get_children():
		child.queue_free()

	# desenha
	for part in snake_body:
		var rect = ColorRect.new()
		rect.size = Vector2(grid_size, grid_size)
		rect.position = part * grid_size
		rect.color = Color(0, 1, 0)
		snake_node.add_child(rect)


func spawn_food():
	# 🍎 spawn dentro da tela (AGORA DINÂMICO)
	food_position = Vector2(
		randi() % grid_width,
		randi() % grid_height
	)
	
	food.position = food_position * grid_size


func game_over():
	timer.stop()
	
	game_over_label.text = "GAME OVER\n    Score: " + str(score)
	game_over_label.visible = true
