extends CharacterBody2D

var speed: float = 250
var velocity_vector := Vector2.ZERO
var player_path: NodePath = "/root/GameScene/Player"
var player

# Tempo para decidir nova direção
var decision_time: float = 1.0
var time_since_last_decision: float = 0.0

func _ready() -> void:
	player = get_node_or_null(player_path)

func _process(delta: float) -> void:
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
		$MrBubbles.play("walk")
		if velocity_vector.x < 0:
			$MrBubbles.flip_h = true
		else:
			$MrBubbles.flip_h = false
	else:
		$MrBubbles.play("idle")

# Função auxiliar para gerar números inteiros aleatórios em um intervalo
func randi_range(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min
