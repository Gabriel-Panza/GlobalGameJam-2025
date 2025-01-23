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
var drop_interval: float = 30.0

var enemy_timer: Timer
var drop_timer: Timer
var atkSpeed_timer: Timer

var timer_path: NodePath = "/root/GameScene/Player/AtkSpeed"

@export var item_scenes: Array[String] = [
	"res://itemHP.tscn",
	"res://itemGold.tscn",
	"res://itemShield.tscn",
	"res://itemBubblegum.tscn",
	"res://itemBoots.tscn"
]

func _ready() -> void:
	atkSpeed_timer = get_node_or_null(timer_path)
	
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


func is_within_map_bounds(position: Vector2) -> bool:
	return position.x >= map_left and position.x <= map_right and position.y >= map_top and position.y <= map_bottom

func clamp_position_to_bounds(position: Vector2) -> Vector2:
	# Ajusta a posição para ficar dentro dos limites do mapa
	position.x = clamp(position.x, map_left+150, map_right-150)
	position.y = clamp(position.y, map_top+150, map_bottom-150)
	return position

func spawn_enemy():
	_spawn_entity("res://enemy.tscn")

func spawn_drop():
	var random_index = randi() % item_scenes.size()
	var resource = item_scenes[random_index]
	_spawn_entity(resource)

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
