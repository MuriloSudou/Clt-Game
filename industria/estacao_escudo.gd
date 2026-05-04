extends StaticBody2D

var jogador_perto = false
var escudo_disponivel = true

func _input(event):
	if jogador_perto and escudo_disponivel and event.is_action_pressed("ui_accept"):
		pegar_escudo()

func pegar_escudo():
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("dar_boost_escudo"):
			body.dar_boost_escudo(15.0) # 10 segundos de invencibilidade!
			iniciar_recarga()

func iniciar_recarga():
	escudo_disponivel = false
	$Sprite2D.modulate = Color(0.3, 0.3, 0.8) # Fica meio azulado/escuro para mostrar que descarregou
	await get_tree().create_timer(15.0).timeout # Espera 15 segundos para recarregar
	escudo_disponivel = true
	$Sprite2D.modulate = Color(1, 1, 1) # Volta à cor normal

# --- SINAIS DE DETECÇÃO ---
func _on_area_2d_body_entered(body):
	if body.has_method("tomar_dano"):
		jogador_perto = true

func _on_area_2d_body_exited(body):
	if body.has_method("tomar_dano"):
		jogador_perto = false
