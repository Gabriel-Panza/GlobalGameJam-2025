extends CharacterBody2D

var speed: float = 600.0
var player_path: NodePath = "/root/GameScene/Player"
var player

# Variáveis para o movimento em arco
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO
var control_point: Vector2 = Vector2.ZERO
var elapsed_time: float = 0.0  # Tempo acumulado
var duration: float = 1.0  # Duração do movimento em segundos
var curve_amplitude: float = 100.0  # Amplitude fixa da curva

func _ready() -> void:
	player = get_node_or_null(player_path)
	if player:
		var mouse_position = get_global_mouse_position()
		start_position = player.global_position + Vector2(-50, 0).rotated(player.rotation)
		end_position = player.global_position + Vector2(50, 0).rotated(player.rotation)

		# Direção normalizada do jogador para o mouse
		var direction_to_mouse = (mouse_position - player.global_position).normalized()

		# Calcula o ponto de controle com uma amplitude fixa
		control_point = (start_position + end_position) / 2 + direction_to_mouse * curve_amplitude

		position = start_position

		# Configurar a rotação inicial do sprite
		look_at(mouse_position)

func _physics_process(delta: float) -> void:
	if speed > 0:
		if elapsed_time < duration:
			elapsed_time += delta
			var t = elapsed_time / duration
			# Calcula a posição ao longo de uma curva de Bézier quadrática
			position = calculate_bezier(t, start_position, control_point, end_position)

			# Atualiza a rotação do sprite para acompanhar o movimento
			if t < 1.0:
				var next_position = calculate_bezier(t + delta / duration, start_position, control_point, end_position)
				look_at(next_position)
		else:
			queue_free()

func calculate_bezier(t: float, p0: Vector2, p1: Vector2, p2: Vector2) -> Vector2:
	# Fórmula da curva de Bézier quadrática
	return (1 - t) * (1 - t) * p0 + 3 * (1 - t) * t * p1 + t * t * p2

func _on_impact_body_entered(body):
	if body.is_in_group("Inimigo"):
		if randf_range(0, 1) <= player.critico:
			body.take_damage(player.ataque * 2)
		else:
			body.take_damage(player.ataque)
		queue_free()
