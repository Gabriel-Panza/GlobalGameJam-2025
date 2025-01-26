extends CharacterBody2D

# Variáveis gerais
var speed: float = 600.0 # Velocidade inicial
var gravity: float = 900.0 # Força gravitacional
var fuse_time: float = 0.5 # Tempo de fusão antes de explodir
var exploded: bool = false
var impact_flash
var sprite
var sound

# Player
var player_path: NodePath = "/root/GameScene/Player"
var player

func _ready() -> void:
	impact_flash = get_node_or_null("ImpactFramePlaceholder")
	impact_flash.modulate = Color.hex(0xCDF5FD)
	sprite = get_node_or_null("Sprite2D")
	sound = get_node_or_null("AudioStreamPlayer2D")
	player = get_node_or_null(player_path)
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	velocity = direction * speed/1.25
	explode_after_timeout()

func _physics_process(delta: float) -> void:
	if exploded:
		return
	
	# Aplica gravidade no eixo Y
	velocity.y += gravity * delta
	position += velocity * delta
	
	if speed == 0:
		queue_free()

func _on_impact_body_entered(body):
	if exploded:
		return

func explode() -> void:
	exploded = true
	show_flash()
	apply_area_damage()
	sound.play()
	await get_tree().create_timer(0.1).timeout
	impact_flash.queue_free()
	sprite.queue_free()

func apply_area_damage() -> void:
	var area = get_node_or_null("Impact")
	if area:
		for body in area.get_overlapping_bodies():
			if body.is_in_group("Inimigo"):
				if randf_range(0, 1) <= player.critico:
					body.take_damage(player.ataque * 2)
					var impacto = preload("res://crit_text.tscn").instantiate()
					impacto.text = impacto.text % "BOOM!"
					impacto.position = body.position
					get_parent().add_child(impacto)
				else:
					body.take_damage(player.ataque)

func explode_after_timeout() -> void:
	await get_tree().create_timer(fuse_time).timeout
	explode()
	
func show_flash() -> void:
	var area = get_node_or_null("Impact/CollisionShape2D")
	if area:
		impact_flash.visible = true


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
