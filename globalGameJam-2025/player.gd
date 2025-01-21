extends CharacterBody2D

var speed := 200
var velocity_vector := Vector2.ZERO

var fundo_width: int = 0
var fundo_height: int = 0

func _ready() -> void:
	var sprite_node = $"../Sprite2D"
	if sprite_node and sprite_node.texture:
		fundo_width = sprite_node.texture.get_width()*9.35
		fundo_height = sprite_node.texture.get_height()*5

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
	var new_position = position + velocity_vector * delta

	# Limitar o movimento dentro do tamanho do fundo
	new_position.x = clamp(new_position.x, 0, fundo_width)
	new_position.y = clamp(new_position.y, 0, fundo_height)
	position = new_position
