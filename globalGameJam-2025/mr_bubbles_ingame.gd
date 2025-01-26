extends CharacterBody2D

var speed: float = 250
var velocity_vector := Vector2.ZERO
var player_path: NodePath = "/root/GameScene/Player"
var player

# Tempo para decidir nova direção
var decision_time: float = 1.0
var time_since_last_decision: float = 0.0
var sprite

func _ready() -> void:
	sprite = get_node_or_null("MrBubbles")
	if GameState.mrBubbles >= 1:
		sprite.frames = load("res://sprites/Personagens/mr bubbles/agent_bubbles.tres")
	player = get_node_or_null(player_path)

func _process(delta: float) -> void:
	if player.speed>0:
		time_since_last_decision += delta
		if time_since_last_decision >= decision_time:
			time_since_last_decision = 0.0
			choose_random_direction()

		velocity_vector = velocity_vector.normalized() * speed
		position += velocity_vector * delta
		animationManager()
		move_and_slide()

func choose_random_direction():
	if player:
		# Gera um vetor aleatório dentro de um pequeno raio ao redor do jogador
		var random_offset = Vector2(randi_range(-50, 50), randi_range(-50, 50)).normalized() * 100
		var target_position = player.position + random_offset
		velocity_vector = (target_position - position).normalized() * speed

func animationManager():
	if velocity_vector.x != 0 or velocity_vector.y != 0:
		sprite.play("walk")
		if velocity_vector.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play("idle")

# Função auxiliar para gerar números inteiros aleatórios em um intervalo
func randi_range(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min
	
func _on_MrBubbles_body_entered(body):
	if body.is_in_group("XP") or body.is_in_group("Gold") or body.is_in_group("HP"):
		if body.is_in_group("XP"):
			player.gain_xp(15)
		elif body.is_in_group("Gold"):
			player.gold += 15
			player.emit_signal("gold_updated", player.gold)
		elif body.is_in_group("HP"):
			player.hp += 15
			player.emit_signal("hp_updated", player.health, player.maxHealth)
		player.emit_signal("stats_updated")
		body.queue_free()
