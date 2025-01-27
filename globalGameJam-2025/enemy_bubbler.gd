extends CharacterBody2D

var navigation_agent
var speed: float = 100.0
var original_speed: float = 100.0
var aparencia

var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player
var camera_path: NodePath = "/root/GameScene/Player/Camera2D"
var camera: Camera2D

var damage_timer
var shoot_timer
var projectile_scene: PackedScene

var min_distance: float = 200.0
var max_distance: float = 300.0
var distance_to_player

var damage: int = 25
var health: int = 1

func _ready() -> void:
	camera = get_node_or_null(camera_path)
	gamescene = get_node_or_null(gamescene_path)
	navigation_agent = get_node_or_null("NavigationAgent2D")
	player = get_node_or_null(player_path)
	aparencia = get_node_or_null("aparencia")
	projectile_scene = preload("res://projectile_boss.tscn")
	damage_timer = get_node_or_null("DamageTimer")
	damage_timer.stop()
	shoot_timer = get_node_or_null("Timer")
	shoot_timer.connect("timeout", Callable(self, "_shoot_projectile"))
	add_to_group("Inimigo")
	
	if navigation_agent and player:
		navigation_agent.target_position = player.global_position

	shoot_timer.start()

func _process(_delta: float) -> void:
	if player and player.speed > 0:
		distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player < min_distance or distance_to_player > max_distance:
			navigation_agent.target_position = player.global_position
			var next_position = navigation_agent.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		
		move_and_slide()
		animationManager()

func _shoot_projectile() -> void:
	if player and speed > 0 and aparencia.animation == "attackFar":
		var projectile = projectile_scene.instantiate()
		projectile.global_position = player.global_position
		gamescene.add_child(projectile)

func take_damage(amount):
	health -= amount
	$RichTextLabel.text = "[wave amp=100 freq=9] [fade] - %s [/fade] [/wave]" % amount
	$RichTextLabel.visible = true
	
	if health <= 0:
		die()
	
	await get_tree().create_timer(1).timeout
	$RichTextLabel.visible = false
	$RichTextLabel.text = "[tornado radius=10 freq=2.2] - %s [/tornado]"

func die() -> void:
	if gamescene:
		gamescene.pause_timers()
	damage_timer.set_paused(true)
	shoot_timer.set_paused(true)
	for obj in get_tree().get_nodes_in_group("Vivos"):
		obj.speed = 0
	aparencia.flip_h = false
	aparencia.play("die")
	camera.position = global_position - camera.global_position
	await get_tree().create_timer(6.5).timeout
	queue_free()
	player.win()

func animationManager():
	if velocity != Vector2.ZERO and distance_to_player < min_distance:
		aparencia.play("attackClose")
	elif velocity != Vector2.ZERO and distance_to_player > max_distance:
		aparencia.play("walk")
	elif distance_to_player > min_distance and distance_to_player < max_distance:
		aparencia.play("attackFar")
	
	# Determinar a direção do jogador em relação ao inimigo
	if player and player.global_position.x > global_position.x:
		aparencia.flip_h = false
	elif player and player.global_position.x < global_position.x:
		aparencia.flip_h = true

func _apply_damage() -> void:
	if player:
		player.take_damage(damage)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Area2D":
		_apply_damage()
		$DamageTimer.start()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Area2D":
		$DamageTimer.stop()
