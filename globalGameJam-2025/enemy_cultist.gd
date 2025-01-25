extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D

var speed: float = 100.0
var original_speed: float = 100.0
@onready var aparencia = $aparencia
var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player

@onready var shoot_timer = $Timer
@onready var projectile_scene: PackedScene = preload("res://projectile_enemy.tscn")

var min_distance: float = 300.0
var max_distance: float = 400.0

var damage: int = 15
var health: int = 60

func _ready() -> void:
	gamescene = get_node_or_null(gamescene_path)
	player = get_node_or_null(player_path)
	shoot_timer.connect("timeout", Callable(self, "_shoot_projectile"))
	add_to_group("Inimigo")
	
	if navigation_agent and player:
		navigation_agent.target_position = player.global_position

	shoot_timer.start()

func _process(_delta: float) -> void:
	if player and speed>0:
		var distance_to_player = global_position.distance_to(player.global_position)
		
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
		
		move_and_slide()
		animationManager()

func _shoot_projectile() -> void:
	if player and speed>0:
		var projectile = projectile_scene.instantiate()
		projectile.position = position
		# Configurar a direção do projétil
		add_child(projectile)

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		
func die() -> void:
	var random = randf_range(0, 1)
	if random <= 0.1:
		gamescene.spawn_drop(position)
	if player:
		gamescene._spawn_xp("res://itemXP.tscn", position)
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
