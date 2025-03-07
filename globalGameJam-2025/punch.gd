extends CharacterBody2D

var speed: float = 600.0
var player_path: NodePath = "/root/GameScene/Player"
var player
var mouse_position
# Variáveis para o movimento em arco
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2.ZERO
var start_position2: Vector2 = Vector2.ZERO
var end_position2: Vector2 = Vector2.ZERO
var control_point: Vector2 = Vector2.ZERO
var control_point2: Vector2 = Vector2.ZERO
var elapsed_time: float = 0.0
var duration: float = 0.8
var curve_amplitude: float = 100.0

var sprite

func _ready() -> void:
	sprite = get_node_or_null("Sprite2D")
	player = get_node_or_null(player_path)
	if player:
		mouse_position = get_global_mouse_position()
		_calculate_swing_positions(mouse_position)
		position = start_position
		
	if is_in_group("PunchDireito"):
		look_at(control_point)
	
func _physics_process(delta: float) -> void:
	if speed > 0:
		if elapsed_time < duration:
			elapsed_time += delta
			var t = elapsed_time / duration
			
			# Primeiro projétil
			if is_in_group("PunchEsquerdo"):
				# Primeiro projétil
				var current_position = calculate_bezier(t, start_position, control_point, control_point)
				position = current_position
			else:
				# Segundo projétil
				var current_position2 = calculate_bezier(t, start_position2, control_point2, control_point2)
				position = current_position2
		else:
			queue_free()
	else:
		queue_free()

func calculate_bezier(t: float, p0: Vector2, p1: Vector2, p2: Vector2) -> Vector2:
	# Fórmula da curva de Bézier quadrática
	return (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2

func _calculate_swing_positions(mouse_position: Vector2) -> void:
	var direction = (mouse_position - player.global_position).normalized()
	var angle = rad_to_deg(direction.angle())

	if angle > 135 or angle <= -135:
		# Mouse está para a esquerda
		start_position = player.global_position + Vector2(0, -75)
		start_position2 = player.global_position + Vector2(0, 75)
		control_point = player.global_position + Vector2(-200, 0)
		control_point2 = player.global_position + Vector2(-200, 0)
		if is_in_group("PunchDireito"):
			rotation_degrees = 45
			scale.x *= -1
	elif angle > 45 and angle <= 135:
		# Mouse está para baixo
		start_position = player.global_position + Vector2(-75, 0)
		start_position2 = player.global_position + Vector2(75, 0)
		control_point = player.global_position + Vector2(0, 150)
		control_point2 = player.global_position + Vector2(0, 150)
		if is_in_group("PunchEsquerdo"):
			rotation_degrees = -30
	elif angle >= -45 and angle <= 45:
		# Mouse está para a direita
		start_position = player.global_position + Vector2(0, 75)
		start_position2 = player.global_position + Vector2(0, -75)
		control_point = player.global_position + Vector2(150, 0)
		control_point2 = player.global_position + Vector2(150, 0)
		if is_in_group("PunchEsquerdo"):
			rotation_degrees = 60
			scale.y *= -1
	elif angle > -135 and angle < -45:
		# Mouse está para cima
		start_position = player.global_position + Vector2(75, 0)
		start_position2 = player.global_position + Vector2(-75, 0)
		control_point = player.global_position + Vector2(0, -150)
		control_point2 = player.global_position + Vector2(0, -150)
		if is_in_group("PunchEsquerdo"):
			rotation_degrees = 135
			scale.x *= -1

func _on_impact_body_entered(body):
	if body.is_in_group("Inimigo"):
		if randf_range(0, 1) <= player.critico:
			body.take_damage(player.ataque * 2)
			var popup = Sprite2D.new()
			popup.visible = true
			if is_in_group("PunchEsquerdo"):
				popup.position = body.position - Vector2(75, 50)
			else:
				popup.position = body.position - Vector2(-75, 50)
			popup.texture = load("res://Crit Ballons/BAM!.png")
			popup.scale *= 3
			popup.add_to_group("Popup")
			get_parent().add_child(popup)
			await get_tree().create_timer(0.4).timeout
			for obj in get_tree().get_nodes_in_group("Popup"):
				obj.queue_free()
		else:
			body.take_damage(player.ataque)
			var direction = (mouse_position - player.global_position).normalized()
			var angle = rad_to_deg(direction.angle())
			var target_position
			if angle > 135 or angle <= -135:
				target_position = Vector2(body.position.x * -100, body.position.y)
			elif angle > 45 and angle <= 135:
				target_position = Vector2(body.position.x, body.position.y * 100)
			elif angle >= -45 and angle <= 45:
				target_position = Vector2(body.position.x * 100, body.position.y)
			elif angle > -135 and angle < -45:
				target_position = Vector2(body.position.x, body.position.y * -100)
			body.position = body.position.move_toward(target_position, get_physics_process_delta_time() * speed)
			queue_free()
