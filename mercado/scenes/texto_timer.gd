extends Label

var tempo_decorrido = 0.0
var ativo = false

func _ready():
	set_process(false) # Começa parado até bater o ponto
	visible = false

func _process(delta):
	tempo_decorrido += delta
	atualizar_display()

func atualizar_display():
	var minutos = int(tempo_decorrido / 60)
	var segundos = int(tempo_decorrido) % 60
	# Formata para ter sempre 2 dígitos (ex: 01:05)
	text = "%02d:%02d" % [minutos, segundos]

func parar():
	set_process(false)
	add_theme_color_override("font_color", Color.YELLOW) # Destaca o tempo final
