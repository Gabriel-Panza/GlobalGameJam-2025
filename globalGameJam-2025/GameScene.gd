extends Node2D

# Adicione os caminhos para os nós dos limites
var limite_esquerdo_path: NodePath = "Limites/LimiteEsquerdo"
var limite_direito_path: NodePath = "Limites/LimiteDireito"
var limite_cima_path: NodePath = "Limites/LimiteCima"
var limite_baixo_path: NodePath = "Limites/LimiteBaixo"

# Variáveis para armazenar os limites
var map_left: float
var map_right: float
var map_top: float
var map_bottom: float

# Intervalo de spawn de inimigos
var spawn_interval: float = 1.5
var spawn_offset: float = 50.0

# Intervalo de drop de itens
var drop_interval: float = 45.0

var enemy_timer: Timer
var drop_timer: Timer
var atkSpeed_timer: Timer
var player

var timer_path: NodePath = "/root/GameScene/Player/AtkSpeed"
var player_path: NodePath = "/root/GameScene/Player"

var spawn_position

@export var item_scenes: Array[String] = [
	"res://itemHP.tscn",
	"res://itemGold.tscn",
	"res://itemShield.tscn",
	"res://itemBubblegum.tscn",
	"res://itemBoots.tscn"
]

# Tempo total em segundos (30 minutos)
var total_time: int = 30 * 60
var cronometro_timer_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/Cronometro/Timer"
var cronometro_timer
var cronometro_label_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/Cronometro"
var cronometro_label
var label2_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/Label2"
var label2
var label2_progress_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/ProgressBar2"
var label2_progress

func _ready() -> void:
	adaptHUD()
	
	cronometro_timer = get_node_or_null(cronometro_timer_path)
	cronometro_timer.set_wait_time(1.0)
	cronometro_timer.set_one_shot(false)
	cronometro_timer.connect("timeout", Callable(self, "_update_cronometro"))
	cronometro_timer.start()
	add_child(cronometro_timer)
	
	player = get_node_or_null(player_path)
	if player:
		player.arma = GameState.arma
		player.selectWeapon()
	atkSpeed_timer = get_node_or_null(timer_path)
	if atkSpeed_timer:
		atkSpeed_timer.set_paused(false)
		
	# Obtenha as posições globais dos nós dos limites
	map_left = get_node(limite_esquerdo_path).global_position.x
	map_right = get_node(limite_direito_path).global_position.x
	map_top = get_node(limite_cima_path).global_position.y
	map_bottom = get_node(limite_baixo_path).global_position.y
	
	# Cria e configura o Timer para inimigos
	enemy_timer = Timer.new()
	enemy_timer.wait_time = spawn_interval
	enemy_timer.one_shot = false
	enemy_timer.autostart = true
	enemy_timer.connect("timeout", Callable(self, "spawn_enemy"))
	add_child(enemy_timer)

	# Cria e configura o Timer para drops de itens
	drop_timer = Timer.new()
	drop_timer.wait_time = drop_interval
	drop_timer.one_shot = false
	drop_timer.autostart = true
	drop_timer.connect("timeout", Callable(self, "spawn_drop"))
	add_child(drop_timer)

func adaptHUD() -> void:
	cronometro_label = get_node_or_null(cronometro_label_path)
	if cronometro_label:
		cronometro_label.visible = true
	label2 = get_node_or_null(label2_path)
	if label2:
		label2.visible  = true
	label2_progress = get_node_or_null(label2_progress_path)
	if label2_progress:
		label2_progress.visible = true

func _update_cronometro_display(time_text: String) -> void:
	if cronometro_label:
		cronometro_label.text = "Time: " + time_text

func _update_cronometro() -> void:
	total_time -= 1

	# Verifica se é o momento de disparar um evento
	# if total_time % (5 * 60) == 0:
		#trigger_event()

	var minutes = total_time / 60
	var seconds = total_time % 60
	var formatted_time = "%02d:%02d" % [minutes, seconds]
	_update_cronometro_display(formatted_time)

	# Verifica se o tempo acabou
	if total_time <= 0:
		cronometro_timer.stop()
		player.die()

func is_within_map_bounds(position: Vector2) -> bool:
	return position.x >= map_left and position.x <= map_right and position.y >= map_top and position.y <= map_bottom

func clamp_position_to_bounds(position: Vector2) -> Vector2:
	# Ajusta a posição para ficar dentro dos limites do mapa
	position.x = clamp(position.x, map_left+333, map_right-333)
	position.y = clamp(position.y, map_top+225, map_bottom-225)
	return position

func spawn_enemy():
	_spawn_entity("res://enemy.tscn", Vector2.ZERO)

func spawn_drop(position: Vector2 = Vector2.ZERO):
	var random_index = randi() % item_scenes.size()
	var resource = item_scenes[random_index]
	if resource in ["res://itemShield.tscn", "res://itemBubblegum.tscn", "res://itemBoots.tscn"]:
		item_scenes.erase(resource)
	_spawn_entity(resource, position)

func _spawn_entity(resource_path: String, positionLoc):
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
		
		if positionLoc == Vector2.ZERO:
			spawn_position = Vector2()
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
		else:
			spawn_position = positionLoc
		
		if not is_within_map_bounds(spawn_position):
			spawn_position = clamp_position_to_bounds(spawn_position)
		
		var resource = load(resource_path)
		if resource:
			var entity = resource.instantiate()
			entity.position = spawn_position
			add_child(entity)

func _spawn_xp(xp_scene_path: String, position: Vector2) -> void:
	# Carrega o arquivo da cena de XP
	var xp_scene = load(xp_scene_path)
	if xp_scene:
		# Instancia a cena de XP
		var xp_instance = xp_scene.instantiate()

		# Define a posição inicial da XP
		xp_instance.position = position

		# Adiciona ao `GameScene` ou ao nó pai desejado
		add_child(xp_instance)

func pause_timers():
	if enemy_timer.is_paused() == false:
		enemy_timer.set_paused(true)
	if drop_timer.is_paused() == false:
		drop_timer.set_paused(true)
	if atkSpeed_timer.is_paused() == false:
		atkSpeed_timer.set_paused(true)

func resume_timers():
	enemy_timer.set_paused(false)
	drop_timer.set_paused(false)
	atkSpeed_timer.set_paused(false)
