extends CharacterBody2D

var speed = 0

@export var damage: int = 25
@export var radius: float = 80.0
@export var warning_animation: String = "warning"
@export var tornado_animation: String = "tornado"

var player_path: NodePath = "/root/GameScene/Player"
var player: Node2D
var animation_player: AnimatedSprite2D

func _ready() -> void:
	player = get_node_or_null(player_path)
	animation_player = get_node_or_null("AnimatedSprite2D")
	if player:
		position = player.global_position
		play_warning_animation()

func _process(delta: float) -> void:
	if player and player.speed <= 0:
		queue_free()

func play_warning_animation() -> void:
	# Configura e executa a animação de aviso
	animation_player.play()
	await get_tree().create_timer(1.25).timeout
	play_tornado_animation()

func play_tornado_animation() -> void:
	# Configura e executa a animação do tornado
	animation_player.animation = tornado_animation
	animation_player.play()

	# Remove o tornado após a animação
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _on_animated_sprite_2d_animation_changed() -> void:
	var area = get_node_or_null("Impact")
	if area:
		for body in area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(damage)
