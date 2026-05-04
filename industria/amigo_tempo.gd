extends Area2D

@export var tempo_bonus: float = 10.0

func _on_body_entered(body):
	print("Passo 1: Alguém encostou no item! Foi o: ", body.name)
	
	if body.name == "Jogador":
		print("Passo 2: Era o jogador! Tentando rodar a animação...")
		
		if body.has_method("mostrar_relogio_ganho"):
			body.mostrar_relogio_ganho()
			print("Passo 3: Animação ativada com sucesso!")
		
		var interface_jogo = get_tree().get_first_node_in_group("interface")
		if interface_jogo:
			print("Passo 4: Interface encontrada! Dando tempo...")
			interface_jogo.ganhar_tempo(tempo_bonus)
		else:
			print("ERRO: A Interface não foi encontrada!")
			
		queue_free()
