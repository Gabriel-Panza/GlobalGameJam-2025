extends CharacterBody2D

# Variáveis de Velocidade
var speed := 600
var velocity_vector := Vector2.ZERO

# Variáveis de Limite de Tela
var fundo_width: int = 0
var fundo_height: int = 0
var new_position

# Variáveis de XP e Nível
@export var level: int = 1
@export var current_xp: int = 0
@export var xp_to_next_level: int = 100

signal xp_updated(current_xp, xp_to_next_level)
signal level_updated(level, current_xp, xp_to_next_level)

func _ready() -> void:
	var sprite_node = $"../Fundo"
	if sprite_node and sprite_node.texture:
		fundo_width = sprite_node.texture.get_width() * sprite_node.scale.x/2
		fundo_height = sprite_node.texture.get_height() * sprite_node.scale.y

func _process(delta: float) -> void:
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

	# Limitar o movimento dentro do tamanho do fundo
	new_position.x = clamp(new_position.x, -fundo_width+150, fundo_width-150)
	new_position.y = clamp(new_position.y, -625, fundo_height-875)
	position = new_position

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
