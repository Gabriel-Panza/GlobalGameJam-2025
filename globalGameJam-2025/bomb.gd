extends CharacterBody2D

# Variáveis gerais
var speed: float = 600.0 # Velocidade inicial
var gravity: float = 900.0 # Força gravitacional
var fuse_time: float = 0.5 # Tempo de fusão antes de explodir
var exploded: bool = false

# Player
var player_path: NodePath = "/root/GameScene/Player"
var player

# ColorRect
var flash

func _ready() -> void:
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

func _on_impact_body_entered(body):
	if exploded:
		return

func explode() -> void:
	exploded = true
	show_flash()
	apply_area_damage()
	queue_free()

func apply_area_damage() -> void:
	var area = get_node_or_null("Impact")
	if area:
		for body in area.get_overlapping_bodies():
			if body.is_in_group("Inimigo"):
				body.take_damage(player.ataque)

func explode_after_timeout() -> void:
	await get_tree().create_timer(fuse_time).timeout
	explode()
	
func show_flash() -> void:
	var area = get_node_or_null("Impact/CollisionShape2D")
	if area:
		flash = ColorRect.new()
		flash.name = "Flash"
		flash.color = Color(1, 1, 1, 0.5)  # Branco semitransparente
		
		# Configura o tamanho e a posição do flash
		if area.shape is CircleShape2D:
			var radius = area.shape.radius
			flash.set_size(Vector2(radius * 2, radius * 2))
		else:
			flash.set_size(Vector2(100, 100))  # Tamanho padrão

		flash.position = area.global_position - flash.size / 2
		get_parent().add_child(flash)

		# Cria animação de desaparecimento manualmente
		if $fade_out_timer.is_stopped():
			$fade_out_timer.start()

func _remove_flash() -> void:
	flash = get_parent().get_node_or_null("Flash")
	if flash:
		flash.queue_free()
		$fade_out_timer.stop()
