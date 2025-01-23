extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D

var speed: float = 100.0
@onready var aparencia = $aparencia
var gamescene_path: NodePath = "/root/GameScene"
var gamescene
var player_path: NodePath = "/root/GameScene/Player"
var player

@onready var damage_timer = $Timer

var damage: int = 15
var health: int = 50

func _ready() -> void:
	gamescene = get_node_or_null(gamescene_path)
	player = get_node_or_null(player_path)
	damage_timer.connect("timeout", Callable(self, "_apply_damage"))
	add_to_group("Inimigo")
	
	if navigation_agent and player:
		navigation_agent.target_position = player.global_position

func _process(_delta: float) -> void:
	if speed > 0:
		if player:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		animationManager()
		move_and_slide()
		
		# Verifica collisão do inimigo
		if (damage_timer.paused):
			damage_timer.set_paused(false)
	else:
		damage_timer.set_paused(true)

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		
func die() -> void:
	var random = randf_range(0,1)
	if random <= 0.1:
		gamescene.spawn_drop()
	if player:
		gamescene._spawn_xp("res://itemXP.tscn", position)
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
