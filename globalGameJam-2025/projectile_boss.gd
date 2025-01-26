extends CharacterBody2D

var target_direction: Vector2 = Vector2.ZERO
var speed: float = 600.0

# Path to the player
var player_path: NodePath = "/root/GameScene/Player"
var player

func _ready() -> void:
	player = get_node_or_null(player_path)
	if player:
		target_direction = (player.global_position - global_position).normalized()

func _physics_process(delta):
	# Move the projectile in the calculated direction
	position += target_direction * speed * delta
	
	# If speed is zero, remove the projectile
	if speed == 0:
		queue_free()

func _on_impact_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(25)
		queue_free()
