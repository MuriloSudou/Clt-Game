extends Node2D

@onready var arrows = {
	0: $Arrows/Left,
	1: $Arrows/Down,
	2: $Arrows/Up,
	3: $Arrows/Right
}

@onready var music = $Music
@onready var label = $Label
@onready var hit_sound = $HitSound
@onready var score_label = $ScoreLabel
@onready var health_bar = $HealthBar
@onready var player = $Player
@onready var anim_timer = $AnimTimer
@onready var enemy = $Enemy

var health = 50
var combo = 0
var score = 0

# 🎵 BPM SYSTEM
var bpm = 140
var beat_time = 60.0 / bpm

var note_scene = preload("res://escritorio/scenes/Note.tscn")

var speed = 120
var strum_line_y = 500
var finished = false

var lane_positions = [150, 400, 700, 1000]

# 🎶 AGORA USANDO BEATS
var notes_data = [
	{"beat": 8.5, "lane": 0},
	{ "beat": 8.5, "lane": 0 },
	{ "beat": 9.25, "lane": 1 },
	{ "beat": 9.75, "lane": 2 },
	{ "beat": 10.25, "lane": 3 },
	{ "beat": 11.25, "lane": 0 },
	{ "beat": 12.25, "lane": 0 },
	{ "beat": 13.0, "lane": 1 },
	{ "beat": 13.5, "lane": 2 },
	{ "beat": 14.0, "lane": 3 },
	{ "beat": 15.0, "lane": 0 },
	{ "beat": 16.75, "lane": 0 },
	{ "beat": 17.25, "lane": 1 },
	{ "beat": 17.75, "lane": 2 },
	{ "beat": 18.5, "lane": 2 },
	{ "beat": 19.5, "lane": 2 },
	{ "beat": 20.5, "lane": 1 },
	{ "beat": 21.0, "lane": 0 },
	{ "beat": 21.25, "lane": 2 },
	{ "beat": 22.5, "lane": 3 },
	{ "beat": 24.25, "lane": 3 },
	{ "beat": 24.75, "lane": 0 },
	{ "beat": 26.0, "lane": 1 },
	{ "beat": 27.0, "lane": 1 },
	{ "beat": 28.0, "lane": 2 },
	{ "beat": 28.25, "lane": 3 },
	{ "beat": 28.75, "lane": 0 },
	{ "beat": 30.0, "lane": 1 },
	{ "beat": 31.75, "lane": 2 },
	{ "beat": 32.25, "lane": 0 },
	{ "beat": 32.75, "lane": 1 },
	{ "beat": 33.5, "lane": 3 },
	{ "beat": 34.5, "lane": 3 },
	{ "beat": 35.25, "lane": 0 },
	{ "beat": 35.75, "lane": 1 },
	{ "beat": 36.25, "lane": 2 },
	{ "beat": 37.5, "lane": 3 },
	{ "beat": 38.75, "lane": 2 },
	{ "beat": 39.25, "lane": 0 },
	{ "beat": 39.75, "lane": 1 },
	{ "beat": 40.25, "lane": 3 },
	{ "beat": 40.75, "lane": 0 },
	{ "beat": 41.75, "lane": 2 },
	{ "beat": 42.25, "lane": 1 },
	{ "beat": 42.75, "lane": 0 },
	{ "beat": 43.0, "lane": 3 },
	{ "beat": 43.5, "lane": 0 },
	{ "beat": 44.0, "lane": 2 },
	{ "beat": 44.5, "lane": 1 },
	{ "beat": 46.0, "lane": 2 },
	{ "beat": 46.25, "lane": 0 },
	{ "beat": 46.75, "lane": 1 },
	{ "beat": 47.25, "lane": 3 },
	{ "beat": 47.75, "lane": 0 },
	{ "beat": 48.25, "lane": 2 },
	{ "beat": 49.5, "lane": 2 },
	{ "beat": 50.0, "lane": 1 },
	{ "beat": 50.5, "lane": 0 },
	{ "beat": 50.75, "lane": 3 },
	{ "beat": 51.5, "lane": 0 },
	{ "beat": 52.0, "lane": 2 },
	{ "beat": 53.5, "lane": 1 },
	{ "beat": 53.75, "lane": 0 },
	{ "beat": 54.25, "lane": 3 },
	{ "beat": 54.75, "lane": 0 },
	{ "beat": 55.25, "lane": 2 },
	{ "beat": 55.75, "lane": 1 },
	{ "beat": 57.0, "lane": 1 },
	{ "beat": 57.5, "lane": 1 },
	{ "beat": 58.0, "lane": 2 },
	{ "beat": 58.5, "lane": 0 },
	{ "beat": 58.75, "lane": 1 },
	{ "beat": 59.25, "lane": 3 },
	{ "beat": 60.75, "lane": 1 },
	{ "beat": 61.25, "lane": 0 },
	{ "beat": 61.5, "lane": 2 },
	{ "beat": 62.25, "lane": 1 },
	{ "beat": 63.0, "lane": 0 },
	{ "beat": 63.25, "lane": 3 },
	{ "beat": 64.5, "lane": 1 },
	{ "beat": 65.0, "lane": 1 },
	{ "beat": 65.25, "lane": 2 },
	{ "beat": 65.75, "lane": 0 },
	{ "beat": 66.25, "lane": 1 },
	{ "beat": 66.75, "lane": 3 },
	{ "beat": 67.75, "lane": 0 },
	{ "beat": 68.75, "lane": 1 },
	{ "beat": 69.5, "lane": 0 },
	{ "beat": 69.75, "lane": 3 },
	{ "beat": 70.25, "lane": 0 },
	{ "beat": 70.75, "lane": 2 },
	{ "beat": 71.0, "lane": 0 },
	{ "beat": 71.5, "lane": 1 },
	{ "beat": 72.0, "lane": 0 },
	{ "beat": 72.25, "lane": 3 },
	{ "beat": 72.75, "lane": 0 },
	{ "beat": 73.25, "lane": 2 },
	{ "beat": 74.25, "lane": 2 },
	{ "beat": 75.25, "lane": 1 },
	{ "beat": 75.5, "lane": 0 },
	{ "beat": 76.0, "lane": 2 },
	{ "beat": 76.5, "lane": 0 },
	{ "beat": 77.0, "lane": 3 },
	{ "beat": 77.5, "lane": 0 },
	{ "beat": 78.0, "lane": 1 },
	{ "beat": 78.5, "lane": 2 },
	{ "beat": 79.0, "lane": 0 },
	{ "beat": 79.25, "lane": 3 },
	{ "beat": 79.5, "lane": 0 },
	{ "beat": 79.75, "lane": 1 },
	{ "beat": 80.25, "lane": 2 },
	{ "beat": 80.75, "lane": 0 },
	{ "beat": 81.75, "lane": 3 },
	{ "beat": 82.75, "lane": 3 },
	{ "beat": 83.25, "lane": 0 },
	{ "beat": 83.75, "lane": 1 },
	{ "beat": 84.0, "lane": 0 },
	{ "beat": 84.5, "lane": 2 },
	{ "beat": 85.0, "lane": 3 },
	{ "beat": 85.5, "lane": 0 },
	{ "beat": 86.0, "lane": 1 },
	{ "beat": 86.25, "lane": 0 },
	{ "beat": 86.5, "lane": 2 },
	{ "beat": 87.0, "lane": 3 },
	{ "beat": 87.5, "lane": 0 },
	{ "beat": 87.75, "lane": 1 },
	{ "beat": 88.25, "lane": 2 },
	{ "beat": 89.25, "lane": 2 },
	{ "beat": 90.25, "lane": 1 },
	{ "beat": 90.5, "lane": 0 },
	{ "beat": 91.0, "lane": 3 },
	{ "beat": 91.5, "lane": 0 },
	{ "beat": 92.0, "lane": 2 },
	{ "beat": 92.75, "lane": 1 },
	{ "beat": 93.0, "lane": 0 },
	{ "beat": 93.5, "lane": 3 },
	{ "beat": 94.0, "lane": 2 },
	{ "beat": 94.5, "lane": 1 },
	{ "beat": 95.0, "lane": 2 },
	{ "beat": 95.25, "lane": 1 },
	{ "beat": 95.75, "lane": 0 },
	{ "beat": 96.75, "lane": 3 },
	{ "beat": 97.75, "lane": 1 },
	{ "beat": 98.25, "lane": 0 },
	{ "beat": 98.5, "lane": 2 },
	{ "beat": 99.0, "lane": 3 },
	{ "beat": 99.75, "lane": 0 },
	{ "beat": 100.0, "lane": 1 },
	{ "beat": 100.5, "lane": 2 },
	{ "beat": 101.5, "lane": 2 },
	{ "beat": 102.25, "lane": 1 },
	{ "beat": 102.75, "lane": 0 },
	{ "beat": 103.25, "lane": 3 },
	{ "beat": 103.75, "lane": 0 },
	{ "beat": 104.0, "lane": 2 },
	{ "beat": 104.25, "lane": 1 },
	{ "beat": 105.5, "lane": 2 },
	{ "beat": 106.0, "lane": 1 },
	{ "beat": 106.5, "lane": 0 },
	{ "beat": 107.0, "lane": 2 },
	{ "beat": 107.5, "lane": 1 },
	{ "beat": 107.75, "lane": 2 },
	{ "beat": 109.25, "lane": 3 },
	{ "beat": 109.75, "lane": 0 },
	{ "beat": 110.25, "lane": 1 },
	{ "beat": 110.5, "lane": 2 },
	{ "beat": 111.25, "lane": 3 },
	{ "beat": 111.5, "lane": 0 },
	{ "beat": 111.75, "lane": 2 },
	{ "beat": 112.75, "lane": 2 },
	{ "beat": 113.0, "lane": 1 },
	{ "beat": 113.5, "lane": 0 },
	{ "beat": 114.0, "lane": 2 },
	{ "beat": 114.5, "lane": 3 },
	{ "beat": 115.0, "lane": 0 },
	{ "beat": 115.5, "lane": 1 },
	{ "beat": 116.75, "lane": 0 },
	{ "beat": 117.25, "lane": 1 },
	{ "beat": 117.75, "lane": 3 },
	{ "beat": 118.25, "lane": 2 },
	{ "beat": 118.75, "lane": 0 },
	{ "beat": 119.0, "lane": 1 },
	{ "beat": 120.5, "lane": 3 },
	{ "beat": 121.0, "lane": 0 },
	{ "beat": 121.25, "lane": 2 },
	{ "beat": 121.75, "lane": 1 },
	{ "beat": 122.5, "lane": 0 },
	{ "beat": 122.75, "lane": 2 },
	{ "beat": 124.25, "lane": 1 },
	{ "beat": 124.75, "lane": 0 },
	{ "beat": 125.25, "lane": 3 },
	{ "beat": 125.75, "lane": 2 },
	{ "beat": 126.25, "lane": 1 },
	{ "beat": 126.5, "lane": 0 },
	{ "beat": 127.5, "lane": 2 },
	{ "beat": 128.0, "lane": 0 },
	{ "beat": 128.5, "lane": 1 },
	{ "beat": 129.0, "lane": 3 },
	{ "beat": 129.5, "lane": 0 },
	{ "beat": 129.75, "lane": 1 },
	{ "beat": 130.25, "lane": 2 },
	{ "beat": 131.25, "lane": 2 },
	{ "beat": 132.25, "lane": 1 },
	{ "beat": 132.5, "lane": 0 },
	{ "beat": 133.0, "lane": 3 },
	{ "beat": 133.5, "lane": 0 },
	{ "beat": 134.0, "lane": 2 },
	{ "beat": 135.0, "lane": 2 },
	{ "beat": 136.5, "lane": 2 },
	{ "beat": 136.75, "lane": 1 },
	{ "beat": 137.75, "lane": 0 },
	{ "beat": 138.5, "lane": 3 },
	{ "beat": 139.0, "lane": 0 },
	{ "beat": 139.25, "lane": 1 },
	{ "beat": 139.75, "lane": 2 },
	{ "beat": 140.25, "lane": 0 },
	{ "beat": 140.5, "lane": 1 },
	{ "beat": 140.75, "lane": 0 },
	{ "beat": 141.25, "lane": 2 },
	{ "beat": 141.5, "lane": 1 },
	{ "beat": 142.5, "lane": 3 },
	{ "beat": 143.25, "lane": 0 },
	{ "beat": 143.75, "lane": 1 },
	{ "beat": 144.25, "lane": 2 },
	{ "beat": 144.75, "lane": 3 },
	{ "beat": 145.25, "lane": 0 },
	{ "beat": 146.5, "lane": 1 },
	{ "beat": 147.0, "lane": 2 },
	{ "beat": 147.5, "lane": 0 },
	{ "beat": 148.0, "lane": 3 },
	{ "beat": 149.0, "lane": 0 },
	{ "beat": 150.5, "lane": 3 },
	{ "beat": 150.75, "lane": 0 },
	{ "beat": 151.25, "lane": 1 },
	{ "beat": 151.75, "lane": 2 },
	{ "beat": 152.5, "lane": 3 },
	{ "beat": 152.5, "lane": 0 },
	{ "beat": 154.25, "lane": 0 },
	{ "beat": 154.75, "lane": 1 },
	{ "beat": 155.0, "lane": 2 },
	{ "beat": 155.75, "lane": 3 },
	{ "beat": 156.0, "lane": 0 },
	{ "beat": 156.5, "lane": 1 },
]

var note_textures = [
	preload("res://escritorio/art/arrow_left.png"),
	preload("res://escritorio/art/arrow_down.png"),
	preload("res://escritorio/art/arrow_up.png"),
	preload("res://escritorio/art/arrow_right.png")
]

func _ready():
	
	music.play()
	label.position = Vector2(500, 200)
	anim_timer.timeout.connect(_on_anim_timer_timeout)
	enemy.play("idle")

func _process(delta):
	var song_time = get_song_time()

	# 👇 CALCULA ANTES DE USAR
	var spawn_y = 0.0
	var distance = strum_line_y - spawn_y
	var travel_time = distance / speed

	# ✅ SPAWN CORRETO COM BPM
	for note_data in notes_data.duplicate():
		var note_time = note_data.beat * beat_time

		var offset = -2.2  # negativo = aparece depois

		if note_time - song_time < travel_time + offset:
			spawn_note(note_data)
			notes_data.erase(note_data)

	# MOVIMENTO DAS NOTAS
	for note in get_tree().get_nodes_in_group("notes"):
		note.position.y += speed * delta

	# UI
	score_label.text = "Score: " + str(score) + "\nCombo: " + str(combo)

	# VIDA
	health = clamp(health, 0, 100)
	health_bar.value = health

	var style = StyleBoxFlat.new()

	if health > 60:
		style.bg_color = Color(0, 1, 0)
	elif health > 30:
		style.bg_color = Color(1, 1, 0)
	else:
		style.bg_color = Color(1, 0, 0)

	health_bar.add_theme_stylebox_override("fill", style)

	if health <= 0:
		game_over()
		
	for note in get_tree().get_nodes_in_group("notes"):
		note.position.y += speed * delta

	# 👇 SE PASSOU DA LINHA E NÃO FOI ACERTADA
		if note.position.y > strum_line_y + 120:
			miss()
			note.queue_free()	
			
	if not music.playing and not finished:
		finished = true
		show_results()

func get_song_time():
	return music.get_playback_position()

func spawn_note(data):
	var n = note_scene.instantiate()

	var time = data.beat * beat_time

	n.position = Vector2(lane_positions[data.lane], 0)
	n.hit_time = time
	n.lane = data.lane

	n.texture = note_textures[data.lane]
	n.scale = Vector2(0.75, 0.75)
	n.add_to_group("notes")
	add_child(n)

# 🎯 INPUT = ANIMAÇÃO + HIT (SEPARADOS)
func _input(event):
	
	if event.is_action_pressed("restart"):
		restart_game()
		
	if event.is_action_pressed("ui_left"):
		play_player_anim(0)
		press_arrow(0)
		check_hit(0)

	if event.is_action_pressed("ui_down"):
		play_player_anim(1)
		press_arrow(1)
		check_hit(1)

	if event.is_action_pressed("ui_up"):
		play_player_anim(2)
		press_arrow(2)
		check_hit(2)

	if event.is_action_pressed("ui_right"):
		play_player_anim(3)
		press_arrow(3)
		check_hit(3)

func check_hit(lane):
	var closest = null
	var smallest_diff = 999

	for note in get_tree().get_nodes_in_group("notes"):
		if note == null or not is_instance_valid(note):
			continue
		if note.lane == lane:
			var diff = abs(note.position.y - strum_line_y)
			if diff < smallest_diff:
				smallest_diff = diff
				closest = note

	if closest != null and is_instance_valid(closest):
		if smallest_diff < 20:
			show_text("PERFECT!", Color(0, 1, 0))
			add_score("perfect")
			show_hit_effect(closest.position)
			remove_note(closest)
			hit_sound.play()

		elif smallest_diff < 50:
			show_text("GOOD!", Color(1, 1, 0))
			add_score("good")
			show_hit_effect(closest.position)
			remove_note(closest)
			hit_sound.play()

		else:
			show_text("MISS!", Color(1, 0, 0))
			miss()
	else:
		show_text("MISS!", Color(1, 0, 0))
		miss()

# 🎮 VISUAL DAS SETAS
func press_arrow(lane):
	var arrow = arrows[lane]

	arrow.scale = Vector2(1.3, 1.3)
	arrow.modulate = Color(1, 1, 0)

	await get_tree().create_timer(0.1).timeout

	arrow.scale = Vector2(1, 1)
	arrow.modulate = Color(1, 1, 1)

# 💥 EFEITO VISUAL
func show_hit_effect(pos):
	var effect = ColorRect.new()
	effect.color = Color(1, 1, 0)
	effect.size = Vector2(40, 40)
	effect.position = pos - effect.size / 2

	add_child(effect)

	var tween = create_tween()
	tween.tween_property(effect, "scale", Vector2(2, 2), 0.1)
	tween.tween_property(effect, "modulate:a", 0, 0.1)

	await tween.finished
	effect.queue_free()

# 🧮 SCORE
func add_score(type):
	if type == "perfect":
		score += 100
		combo += 1
		health += 5

	elif type == "good":
		score += 50
		combo += 1
		health += 2

func miss():
	combo = 0
	health -= 10
	enemy.play("laugh")
	await get_tree().create_timer(0.5).timeout
	enemy.play("idle")

# ❌ REMOVE NOTA
func remove_note(note):
	if note == null or not is_instance_valid(note):
		return

	var tween = create_tween()
	tween.tween_property(note, "scale", Vector2(0, 0), 0.1)
	tween.tween_property(note, "modulate:a", 0, 0.1)

	await tween.finished

	if is_instance_valid(note):
		note.queue_free()

# 📝 TEXTO
func show_text(text, color):
	label.text = text
	label.modulate = color
	label.scale = Vector2(1.5, 1.5)

	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(label, "modulate:a", 0, 0.3)

	await tween.finished
	label.modulate.a = 1

# ☠️ GAME OVER
func game_over():
	label.text = "GAME OVER"
	get_tree().paused = true

# 🎬 ANIMAÇÃO PLAYER
func play_player_anim(lane):
	match lane:
		0:
			player.play("left")
		1:
			player.play("down")
		2:
			player.play("up")
		3:
			player.play("right")

	if not anim_timer.is_stopped():
		anim_timer.stop()

	anim_timer.start()

func _on_anim_timer_timeout():
	player.play("idle")
	
func show_results():
	get_tree().paused = true
	
	label.text = "FIM!\n\nScore: " + str(score) + "\nCombo: " + str(combo) + "\n\nPressione R para reiniciar"
	label.modulate = Color(1, 1, 1)
	label.scale = Vector2(1.5, 1.5)	
	
func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()	
