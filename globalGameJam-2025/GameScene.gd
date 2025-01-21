extends Node2D

# Intervalo de spawn de inimigos
var spawn_interval: float = 0.75
var spawn_offset: float = 50.0

# Intervalo de drop de itens
var drop_interval: float = 30.0

func _ready() -> void:
	# Cria e configura o Timer para inimigos
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = spawn_interval
	enemy_timer.one_shot = false
	enemy_timer.autostart = true
	add_child(enemy_timer)

	# Conecta o sinal `timeout` ao método `spawn_enemy`
	enemy_timer.connect("timeout", Callable(self, "spawn_enemy"))
	
	# Cria e configura o Timer para drops de itens
	var drop_timer = Timer.new()
	drop_timer.wait_time = drop_interval
	drop_timer.one_shot = false
	drop_timer.autostart = true
	add_child(drop_timer)

	# Conecta o sinal `timeout` ao método `spawn_drop`
	drop_timer.connect("timeout", Callable(self, "spawn_drop"))

func spawn_enemy():
	_spawn_entity("res://enemy.tscn")

func spawn_drop():
	_spawn_entity("res://item_drop.tscn")

func _spawn_entity(resource_path: String):
	var camera = get_tree().get_current_scene().get_node("Player/Camera2D")
	if camera:
		# Obtenha o centro e o tamanho da área visível da câmera
		var camera_pos = camera.global_position
		var viewport_size = get_viewport().get_visible_rect().size / 2
		
		# Calcule as bordas da câmera
		var left = camera_pos.x - viewport_size.x - spawn_offset
		var right = camera_pos.x + viewport_size.x + spawn_offset
		var top = camera_pos.y - viewport_size.y - spawn_offset
		var bottom = camera_pos.y + viewport_size.y + spawn_offset

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
		
		var resource = load(resource_path)
		if resource:
			var entity = resource.instantiate()
			entity.position = spawn_position
			add_child(entity)
