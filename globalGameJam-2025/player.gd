extends CharacterBody2D

# Variáveis de Velocidade
var speed: float = 250
var original_speed: float = 200
var velocity_vector := Vector2.ZERO
var pause_control_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl"
var pause_control: Control
var game_over_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/GameOver"
var game_over: Panel
var game_scene_path: NodePath = "/root/GameScene"
var game_scene: Node
var arma
var projetil
@onready var aparencia = $Aparencia
var new_position

# Variaveis de HUD
var health = 200
var original_health = 200
var maxHealth = 200
var original_maxHealth = 200
var gold = 0
var ataque = 25
var original_ataque = 25
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

var tela_inicial: bool = false

var weapon_data = {
	"res://projectile.tscn": "res://sprites/Weapons/Bubble_Gun.png",
	"res://bomb.tscn": "res://sprites/Weapons/Explubble_Bomb.png",
	"res://punch.tscn": "res://sprites/Weapons/Soap_Gauntlet.png"
}

func _ready() -> void:
	pause_control = get_node_or_null(pause_control_path)
	game_over = get_node_or_null(game_over_path)
	game_scene = get_node_or_null(game_scene_path)

func animationManager():
	if velocity_vector.x != 0 or velocity_vector.y != 0:
		aparencia.play("walk")
		$MrBubbles.play("walk")
		if velocity_vector.x < 0:
			aparencia.flip_h = true
			$MrBubbles.flip_h = false
		else:
			aparencia.flip_h = false
			$MrBubbles.flip_h = true
	else:
		aparencia.play("idle")
		$MrBubbles.play("idle")

func _process(delta: float) -> void:
	if tela_inicial:
		$MrBubbles.visible = false
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
		animationManager()
		move_and_slide()

func gain_xp(amount: int) -> void:
	current_xp += amount
	emit_signal("xp_updated", current_xp, xp_to_next_level)

	# Verifica se o jogador subiu de nível
	if current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level_up()

func level_up() -> void:
	level += 1
	xp_to_next_level = int(xp_to_next_level * 1.5)  # Aumenta o requisito de XP
	emit_signal("level_updated", level, current_xp, xp_to_next_level)

func _on_atk_speed_timeout():
	if projetil:
		var tiro = projetil.instantiate()
		tiro.position = position
		if tiro.is_in_group("Punch"):
			tiro.add_to_group("PunchEsquerdo")
			var tiro2 = projetil.instantiate()
			tiro2.add_to_group("PunchDireito")
			tiro2.position = position
			owner.add_child(tiro2)
		elif tiro.is_in_group("Bomb"):
			owner.add_child(tiro)
			return
		else:
			tiro.direction = (position - get_global_mouse_position()).normalized()
		owner.add_child(tiro)

func take_damage(amount):
	var shield = get_node_or_null("/root/GameScene/Player/Shield")
	if shield and shield.visible:
		shield.visible = false
	else:
		health -= amount
		emit_signal("hp_updated", health, maxHealth)
		emit_signal("stats_updated")
		if health <= 0:
			die()

func die():
	if game_scene:
		game_scene.pause_timers()
	for obj in get_tree().get_nodes_in_group("Vivos"):
		obj.speed = 0
	GameState.gold += gold
	GameState.arma = arma
	GameState.save_game()
	game_over.visible = true

func selectWeapon():
	match arma:
		"res://projectile.tscn":
			pause_control.slots[0].texture = load(weapon_data[arma])
			projetil = preload("res://projectile.tscn")
			ataque = 25
			original_ataque = 25
			$AtkSpeed.wait_time = 1
			$AtkSpeed.set_paused(true)
			if tela_inicial:
				$"../BubbleGun/BubbleGun2".set_modulate(Color.TRANSPARENT)
				$"../ExplubbleBomb/ExplubbleBomb2".set_modulate(Color.WHITE)
				$"../SoapGauntlet/SoapGauntlet2".set_modulate(Color.WHITE)

		"res://bomb.tscn":
			pause_control.slots[0].texture = load(weapon_data[arma])
			projetil = preload("res://bomb.tscn")
			ataque = 40
			original_ataque = 40
			$AtkSpeed.wait_time = 3
			$AtkSpeed.set_paused(true)
			if tela_inicial:
				$"../BubbleGun/BubbleGun2".set_modulate(Color.WHITE)
				$"../ExplubbleBomb/ExplubbleBomb2".set_modulate(Color.TRANSPARENT)
				$"../SoapGauntlet/SoapGauntlet2".set_modulate(Color.WHITE)

		"res://punch.tscn":
			pause_control.slots[0].texture = load(weapon_data[arma])
			projetil = preload("res://punch.tscn")
			ataque = 8
			original_ataque = 10
			$AtkSpeed.wait_time = 0.5
			$AtkSpeed.set_paused(true)
			if tela_inicial:
				$"../BubbleGun/BubbleGun2".set_modulate(Color.WHITE)
				$"../ExplubbleBomb/ExplubbleBomb2".set_modulate(Color.WHITE)
				$"../SoapGauntlet/SoapGauntlet2".set_modulate(Color.TRANSPARENT)
	GameState.arma = arma
	ataque += (original_ataque * 0.20) * GameState.ataque
	$AtkSpeed.wait_time -= ($AtkSpeed.wait_time * 0.10) * GameState.atkSpeed
