extends CharacterBody2D

var speed: float = 100.0

var player_path: NodePath = "/root/GameScene/Player"
var player

var xp_reward: int = 15

func _ready() -> void:
	player = get_node_or_null(player_path)
	add_to_group("Inimigo")

func _process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	# Move o inimigo
	move_and_slide()

func die() -> void:
	if player:
		player.gain_xp(xp_reward)
	queue_free()

# Callback para o sinal body_entered
func _on_body_entered(body: Node) -> void:
	if body == player:
		die()
