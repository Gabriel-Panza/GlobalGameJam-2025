extends CharacterBody2D

var speed := 200
var velocity_vector := Vector2.ZERO

var fundo_width: int = $"../../Sprite2D".texture.get_width()
var fundo_height: int = $"../../Sprite2D".texture.get_height()

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity_vector.y -= 1

	velocity_vector = velocity_vector.normalized() * speed
	var new_position = position + velocity_vector * delta

	# Limitar o movimento dentro do tamanho do fundo
	new_position.x = clamp(new_position.x, 0, fundo_width)
	new_position.y = clamp(new_position.y, 0, fundo_height)
	position = new_position
