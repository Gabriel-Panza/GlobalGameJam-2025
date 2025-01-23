extends CharacterBody2D

# Variáveis de Velocidade
var speed: float = 300
var original_speed: float = 300
var velocity_vector := Vector2.ZERO
var arma = "res://sprites/Weapons/Bubble_Gun.png"
var projetil

var new_position

# Variaveis de HUD
var health = 200
var original_health = 200
var maxHealth = 200
var original_maxHealth = 200
var gold = 0
var ataque = 20
var original_ataque = 20
var critico = 0
var original_critico = 0
var atkSpeed = 1

# Variáveis de XP e Nível
@export var level: int = 1
@export var current_xp: int = 0
@export var xp_to_next_level: int = 100

signal xp_updated(current_xp, xp_to_next_level)
signal level_updated(level, current_xp, xp_to_next_level)
signal hp_updated(health, maxHealth)
signal gold_updated(gold)
signal stats_updated()

func _process(delta: float) -> void:
	if speed > 0:
		velocity_vector.x = 0
		velocity_vector.y = 0
		if Input.is_action_pressed("ui_right"):
			velocity_vector.x += 300
		if Input.is_action_pressed("ui_left"):
			velocity_vector.x -= 300
		if Input.is_action_pressed("ui_down"):
			velocity_vector.y += 300
		if Input.is_action_pressed("ui_up"):
			velocity_vector.y -= 300

		velocity_vector = velocity_vector.normalized() * speed
		new_position = position + velocity_vector * delta
		position = new_position
		move_and_slide()

func gain_xp(amount: int) -> void:
	current_xp += amount
	emit_signal("xp_updated", current_xp, xp_to_next_level)

	# Verifica se o jogador subiu de nível
	while current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level_up()

func level_up() -> void:
	level += 1
	xp_to_next_level = int(xp_to_next_level * 1.5)  # Aumenta o requisito de XP
	emit_signal("level_updated", level, current_xp, xp_to_next_level)

func _on_atk_speed_timeout():
	var tiro = projetil.instantiate()
	tiro.position = position
	tiro.direction = (position - get_global_mouse_position()).normalized()
	owner.add_child(tiro)

func collect_item(value, type):
	if type == "itemGold":
		gold += value
		emit_signal("gold_updated", gold)
	if type == "itemXP":
		gain_xp(value)
	if type == "itemHP":
		if health+value <= maxHealth:
			health += value
		else:
			health = maxHealth
		emit_signal("hp_updated", health, maxHealth)
	emit_signal("stats_updated")

func take_damage(amount):
	health -= amount
	emit_signal("hp_updated", health, maxHealth)
	emit_signal("stats_updated")
	if health <= 0:
		die()

func die():
	print("Player died")

func selectWeapon():
	print("entrou")
	var pauseMenu = $Camera2D/CanvasLayer/HUD/PauseControl
	pauseMenu.slots[0].set_texture(load("res://sprites/Weapons/Soap_Gauntlet.png"))
	arma = pauseMenu.slots[0].texture.resource_path
	print(arma)
	match arma:
		"res://sprites/Weapons/Bubble_Gun.png":
			projetil = preload("res://projectile.tscn")
		"res://sprites/Weapons/Explubble_Bomb.png":
			projetil = preload("res://bomb.tscn")
			atkSpeed = 3
			ataque = 40
			$AtkSpeed.wait_time = atkSpeed
		"res://sprites/Weapons/Soap_Gauntlet.png":
			atkSpeed = 0.25
			ataque = 10
			$AtkSpeed.wait_time = atkSpeed
			projetil = preload("res://punch.tscn")
	
