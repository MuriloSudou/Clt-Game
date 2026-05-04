extends StaticBody2D

var jogador_perto = false
var cafe_disponivel = true

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Botão pressionado. Jogador perto? ", jogador_perto) # E isto!
		
	if jogador_perto and cafe_disponivel and event.is_action_pressed("ui_accept"):
		tomar_cafe()

func tomar_cafe():
	print("☕ Tentando fazer café...")
	var corpos = $AreaCafeteira.get_overlapping_bodies()
	print("Tem ", corpos.size(), " coisas perto da cafeteira.")
	
	for body in corpos:
		print("Analisando o objeto: ", body.name)
		if body.has_method("dar_boost_cafe"):
			print("✅ Achei o jogador! Dando boost...")
			body.dar_boost_cafe(12.0)
			iniciar_recarga()
		else:
			print("❌ O objeto ", body.name, " NÃO tem a função dar_boost_cafe!")

func iniciar_recarga():
	cafe_disponivel = false
	$Sprite2D.modulate = Color(0.5, 0.5, 0.5) # Escurece a cafeteira
	await get_tree().create_timer(10.0).timeout # 10 segundos de cooldown
	cafe_disponivel = true
	$Sprite2D.modulate = Color(1, 1, 1) # Volta ao normal

# --- SINAIS DE DETECÇÃO ---
func _on_area_2d_body_entered(body):
	print("🚨 ALGUÉM PISOU NA CAFETEIRA: ", body.name) # Adicione isto!
	if body.name == "Jogador":
		jogador_perto = true
		print("☕ JOGADOR RECONHECIDO!") # E isto!

func _on_area_2d_body_exited(body):
	if body.name == "Jogador":
		jogador_perto = false
