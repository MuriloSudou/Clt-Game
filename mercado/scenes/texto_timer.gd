extends Label

var tempo_restante = 60.0
var ativo = false

func _ready():
	set_process(false)
	visible = false

func iniciar():
	tempo_restante = 60.0
	visible = true
	set_process(true)

func _process(delta):
	tempo_restante -= delta
	
	if tempo_restante <= 0:
		tempo_restante = 0
		atualizar_display()
		tempo_esgotado()
		return
	
	atualizar_display()

func atualizar_display():
	var minutos = int(tempo_restante / 60)
	var segundos = int(tempo_restante) % 60
	
	text = "%02d:%02d" % [minutos, segundos]

func tempo_esgotado():
	set_process(false)
	add_theme_color_override("font_color", Color.RED)
	
	text = "TEMPO ESGOTADO!\nACELERE E TERMINE ISSO!"
	
	await get_tree().create_timer(3.0).timeout
	
	text = "NÃO PARE DE TRABALHAR!"
func parar():
	set_process(false)
	add_theme_color_override("font_color", Color.YELLOW)
