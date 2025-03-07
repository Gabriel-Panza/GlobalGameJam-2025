extends CharacterBody2D

var navigation_agent

var speed: float = 100.0
var original_speed: float = 100.0
var aparencia

var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player

var shoot_timer
var projectile_scene: PackedScene

var min_distance: float = 200.0
var max_distance: float = 375.0
var distance_to_player

var damage: int = 15
var health: int = 60

func _ready() -> void:
	gamescene = get_node_or_null(gamescene_path)
	navigation_agent = get_node_or_null("NavigationAgent2D")
	player = get_node_or_null(player_path)
	aparencia = get_node_or_null("aparencia")
	projectile_scene = preload("res://projectile_enemy.tscn")
	shoot_timer = get_node_or_null("Timer")
	shoot_timer.connect("timeout", Callable(self, "_shoot_projectile"))
	add_to_group("Inimigo")
	
	if navigation_agent and player:
		navigation_agent.target_position = player.global_position

	shoot_timer.start()

func _process(_delta: float) -> void:
	if player and player.speed>0:
		distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player < min_distance:
			# Fugir do jogador
			var direction = (global_position - player.global_position).normalized()
			velocity = direction * speed
		elif distance_to_player > max_distance:
			# Aproximar-se do jogador até a distância máxima
			navigation_agent.target_position = player.global_position
			var next_position = navigation_agent.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		shoot_timer.set_paused(false)
		speed = original_speed
		
		move_and_slide()
		animationManager()
	else:
		shoot_timer.set_paused(true)
		speed = 0

func _shoot_projectile() -> void:
	if  distance_to_player > min_distance and distance_to_player < max_distance and player and speed>0:
		var projectile = projectile_scene.instantiate()
		projectile.position = Vector2.ZERO
		# Configurar a direção do projétil
		add_child(projectile)

func take_damage(amount):
	health -= amount
	$RichTextLabel.visible = true
	$RichTextLabel.text = "[wave amp=100 freq=9] [fade] - %s [/fade] [/wave]" % amount
	if health <= 0:
		die()
	await get_tree().create_timer(1).timeout
	$RichTextLabel.visible = false
	$RichTextLabel.text = "[tornado radius = 10 freq = 2.2] - %s [/tornado]"
		
func die() -> void:
	var random = randf_range(0, 1)
	if random <= 0.4:
		gamescene.spawn_drop(position-Vector2(100,100))
	if player:
		gamescene._spawn_xp("res://itemBigXP.tscn", position+Vector2(100,100))
	queue_free()

func animationManager():
	if velocity != Vector2.ZERO:
		aparencia.play("walk")
	else:
		aparencia.play("attack")

	# Determinar a direção do jogador em relação ao inimigo
	if player and player.global_position.x > global_position.x:
		aparencia.flip_h = true
	elif player and player.global_position.x < global_position.x:
		aparencia.flip_h = false
