extends Node2D

var spawn_interval: float = 1.0
var spawn_offset: float = 50.0

func _ready() -> void:
	# Cria e configura o Timer
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false  # Faz o timer repetir
	timer.autostart = true  # Inicia automaticamente
	add_child(timer)

	# Conecta o sinal `timeout` ao método `spawn_enemy`
	timer.connect("timeout", Callable(self, "spawn_enemy"))

func spawn_enemy():
	var camera = get_tree().get_current_scene().get_node("Player/Camera2D")  # Ajuste o caminho para a câmera
	if camera:
		# Obtenha o centro e o tamanho da área visível da câmera
		var camera_pos = camera.global_position
		var viewport_size = get_viewport().get_visible_rect().size / 2  # Metade do tamanho do viewport (centro)
		
		# Calcule as bordas da câmera
		var left = camera_pos.x - viewport_size.x - spawn_offset
		var right = camera_pos.x + viewport_size.x + spawn_offset
		var top = camera_pos.y - viewport_size.y - spawn_offset
		var bottom = camera_pos.y + viewport_size.y + spawn_offset

		# Escolha uma borda aleatória
		var spawn_position = Vector2()
		var side = randi() % 4  # 0 = top, 1 = bottom, 2 = left, 3 = right
		
		match side:
			0:  # Top
				spawn_position.x = randf_range(left, right)
				spawn_position.y = top
			1:  # Bottom
				spawn_position.x = randf_range(left, right)
				spawn_position.y = bottom
			2:  # Left
				spawn_position.x = left
				spawn_position.y = randf_range(top, bottom)
			3:  # Right
				spawn_position.x = right
				spawn_position.y = randf_range(top, bottom)
		
		# Instancie o inimigo na posição escolhida
		var enemy = preload("res://enemy.tscn").instantiate()
		enemy.position = spawn_position
		add_child(enemy)
