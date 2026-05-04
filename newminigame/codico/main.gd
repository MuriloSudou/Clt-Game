extends Node2D

@onready var snake = $Monitor/Screen/SnakeGame
@onready var excel = $FakeExcel
@onready var boss_warning = $BossWarning
@onready var boss_timer = $TimerBoss
@onready var boss_game_over = $BossGameOver

var is_working = false
var game_over_flag = false


func _ready():
	randomize()
	update_screen()
	start_boss_timer()


func _unhandled_input(event):
	# 🔁 RESTART (funciona pausado)
	if event.is_action_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()

	# 🔄 TROCAR TELA (ESSA PARTE FALTAVA)
	if event.is_action_pressed("switch_screen") and not game_over_flag:
		is_working = !is_working
		update_screen()


func update_screen():
	snake.visible = not is_working
	excel.visible = is_working


func start_boss_timer():
	var time = randf_range(5, 10)
	boss_timer.start(time)


func _on_timer_boss_timeout():
	if game_over_flag:
		return
	
	show_boss_warning()


func show_boss_warning():
	boss_warning.visible = true
	boss_warning.modulate.a = 0

	# ✨ fade in (funciona pausado)
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(boss_warning, "modulate:a", 1, 0.3)

	await get_tree().create_timer(1.5, true).timeout

	if not excel.visible:
		trigger_game_over()
	else:
		# ✨ fade out
		var tween2 = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween2.tween_property(boss_warning, "modulate:a", 0, 0.3)

		await tween2.finished
		boss_warning.visible = false
		start_boss_timer()


func trigger_game_over():
	game_over_flag = true
	
	get_tree().paused = true
	
	boss_warning.visible = false
	boss_game_over.visible = true
	boss_game_over.scale = Vector2(2, 2)
