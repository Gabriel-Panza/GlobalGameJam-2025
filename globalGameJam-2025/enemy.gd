extends CharacterBody2D

var navigation_agent

var speed: float = 100.0
var original_speed: float = 100.0
var aparencia

var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player

var damage_timer

var damage: int = 15
var health: int = 50

func _ready() -> void:
	gamescene = get_node_or_null(gamescene_path)
	player = get_node_or_null(player_path)
	navigation_agent = get_node_or_null("NavigationAgent2D")
	aparencia = get_node_or_null("aparencia")
	damage_timer = get_node_or_null("Timer")
	add_to_group("Inimigo")
	
	if navigation_agent and player:
		navigation_agent.target_position = player.global_position

func _process(_delta: float) -> void:
	if player and player.speed>0:
		# Atualizar a posição do alvo no NavigationAgent2D
		navigation_agent.target_position = player.global_position
		
		# Obter a próxima posição no caminho e calcular direção
		var next_position = navigation_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * speed
		
		move_and_slide()
		animationManager()
		
		# Verifica collisão do inimigo
		if (damage_timer.paused):
			damage_timer.set_paused(false)
	else:
		damage_timer.set_paused(true)

func take_damage(amount):
	health -= amount
	$RichTextLabel.text = "[wave amp=100 freq=9] [fade] - %s [/fade] [/wave]" % amount
	$RichTextLabel.visible = true
	
	if health <= 0:
		die()
		
	await get_tree().create_timer(1).timeout
	$RichTextLabel.visible = false
	$RichTextLabel.text = "[tornado radius = 10 freq = 2.2] - %s [/tornado]"

func die() -> void:
	var random = randf_range(0,1)
	if random <= 0.2:
		gamescene.spawn_drop(position-Vector2(50,50))
	if player:
		gamescene._spawn_xp("res://itemXP.tscn", position+Vector2(50,50))
	queue_free()

func _apply_damage() -> void:
	if player:
		player.take_damage(damage)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Corpo":
		_apply_damage()
		damage_timer.start()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Corpo":
		damage_timer.stop()

func animationManager():
	aparencia.play("default")
