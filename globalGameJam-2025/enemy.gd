extends CharacterBody2D

var speed: float = 100.0

var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player

@onready var damage_timer = $Timer

var xp_reward: int = 15
var damage: int = 15
var health: int = 50

func _ready() -> void:
	gamescene = get_node_or_null(gamescene_path)
	player = get_node_or_null(player_path)
	damage_timer.connect("timeout", Callable(self, "_apply_damage"))
	add_to_group("Inimigo")

func _process(_delta: float) -> void:
	if speed > 0:
		if player:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		# Move o inimigo
		var collision = move_and_collide(velocity * _delta)
		if collision and collision.get_collider() == player:
			if damage_timer.is_stopped():
				_apply_damage()
				damage_timer.start()
		else:
			if not damage_timer.is_stopped():
				damage_timer.stop()

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		
func die() -> void:
	var random = randf_range(0,1)
	if random <= 0.1:
		gamescene.spawn_drop()
	if player:
		player.gain_xp(xp_reward)
	queue_free()

func _apply_damage() -> void:
	if player:
		player.take_damage(damage)
