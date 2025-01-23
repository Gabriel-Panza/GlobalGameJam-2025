extends Control

var game_scene_path: NodePath = "/root/GameScene"
var game_scene
var pause_menu_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu"
var pause_menu: Panel
var options_menu_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/OptionsMenu"
var options_menu: Panel
var health_label_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/HP_MaxHealth"
var health_label: Label
var attack_label_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/Ataque"
var attack_label: Label
var atk_speed_label_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/Atk_Speed"
var atk_speed_label: Label
var crit_label_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/Critico"
var crit_label: Label
var speed_label_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/Speed"
var speed_label: Label
var player_path: NodePath = "/root/GameScene/Player"
var player

var speedPlayer
var speedEnemy
var speedProjectile

# Referências aos slots
var slot1_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/HBoxContainer/Slot1"
var slot1: TextureRect
var slot2_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/HBoxContainer/Slot2"
var slot2: TextureRect
var slot3_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/HBoxContainer/Slot3"
var slot3: TextureRect
var slot4_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/PauseMenu/HBoxContainer/VBoxContainer2/HBoxContainer/Slot4"
var slot4: TextureRect

var itemBublegum: bool
var itemBoots: bool
var itemShield: bool

var slots = []

var bubblegum_timer: Timer
var boots_timer: Timer
var shield: Node2D

func _ready() -> void:
	slot1 = get_node_or_null(slot1_path)
	slot2 = get_node_or_null(slot2_path)
	slot3 = get_node_or_null(slot3_path)
	slot4 = get_node_or_null(slot4_path)

	player = get_node_or_null(player_path)
	game_scene = get_node_or_null(game_scene_path)
	pause_menu = get_node_or_null(pause_menu_path)
	options_menu = get_node_or_null(options_menu_path)
	
	health_label = get_node_or_null(health_label_path)
	attack_label = get_node_or_null(attack_label_path)
	atk_speed_label = get_node_or_null(atk_speed_label_path)
	crit_label = get_node_or_null(crit_label_path)
	speed_label = get_node_or_null(speed_label_path)
	
	slots = [slot1, slot2, slot3, slot4]
	itemBublegum = false
	itemBoots = false
	itemShield = false
	
	# Conecta o sinal do temporizador para criar a partícula rosa a cada 5 segundos
	bubblegum_timer = Timer.new()
	bubblegum_timer.set_wait_time(5.0)
	bubblegum_timer.set_one_shot(false)
	bubblegum_timer.connect("timeout", Callable(self, "_create_bubblegum_particle"))
	bubblegum_timer.start()
	player.add_child(bubblegum_timer)
	
	boots_timer = Timer.new()
	boots_timer.set_wait_time(0.5)
	boots_timer.set_one_shot(false)
	boots_timer.connect("timeout", Callable(self, "_create_boots_particle"))
	boots_timer.start()
	player.add_child(boots_timer)
	
	player.connect("stats_updated", Callable(self, "update_status_labels"))
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if pause_menu.is_visible():
			_unpause_game()
		else:
			_pause_game()

	# Lógica do item Shield
	if itemShield:
		if not is_instance_valid(shield):
			shield = preload("res://itemShield.tscn").instantiate()
			shield.name = "Shield"
			shield.z_index = 2
			shield.position = Vector2.ZERO
			player.add_child(shield)
			await get_tree().create_timer(20.0).timeout
			if shield:
				shield.queue_free()
		else:
			shield.position = Vector2.ZERO

func _create_bubblegum_particle() -> void:
	if itemBublegum:
		var bubblegum_particle = GPUParticles2D.new()
		bubblegum_particle.set_one_shot(true)
		bubblegum_particle.set_lifetime(2.0)
		# Configura a cor das partículas
		var material = ShaderMaterial.new()
		material.shader = Shader.new()
		material.shader_code = """
								shader_type canvas_item;

								void fragment() {
									COLOR = vec4(1.0, 0.0, 1.0, 1.0);
								}
								"""
		bubblegum_particle.material = material
		bubblegum_particle.z_index = 1
		bubblegum_particle.position = player.position
		bubblegum_particle.collision_layer = 3
		bubblegum_particle.collision_mask = 2
		bubblegum_particle.connect("body_entered", Callable(self, "_on_bubblegum_body_entered"))
		player.add_child(bubblegum_particle)

func _on_bubblegum_body_entered(body):
	if body.is_in_group("Inimigo"):
		body.speed *= 0.5  # Reduz a velocidade dos inimigos em 50%
		await get_tree().create_timer(2.0).timeout
		body.speed *= 2.0  # Restaura a velocidade original depois de 2 segundos

func _create_boots_particle() -> void:
	if itemBoots:
		var particle = GPUParticles2D.new()
		particle.set_one_shot(true)
		particle.set_lifetime(0.5)
		# Configura a cor das partículas
		var material = ShaderMaterial.new()
		material.shader = Shader.new()
		material.shader_code = """
								shader_type canvas_item;

								void fragment() {
									COLOR = vec4(1.0, 1.0, 1.0, 1.0);
								}
								"""
		particle.material = material
		particle.z_index = 1
		particle.position = player.position
		player.add_child(particle)

func update_status_labels():
	if player:
		health_label.text = "Health: %d/%d" % [player.health, player.maxHealth]
		attack_label.text = "Attack: %d" % player.ataque
		atk_speed_label.text = "Atk-Speed: %.2f%%" % (player.atkSpeed * 100)
		crit_label.text = "Crit-Rate: %.2f%%" % (player.critico * 100)
		speed_label.text = "Speed: %.2f" % player.speed

func _pause_game():
	update_status_labels()
	pause_menu.show()
	if game_scene:
		game_scene.pause_timers()
	
	for obj in get_tree().get_nodes_in_group("Vivos"):
		if obj in get_tree().get_nodes_in_group("Inimigo"):
			speedEnemy = obj.speed
		elif obj in get_tree().get_nodes_in_group("Player"):
			speedPlayer = obj.speed
		else:
			speedProjectile = obj.speed
		obj.speed = 0

func _unpause_game():
	options_menu.hide()
	pause_menu.hide()
	for obj in get_tree().get_nodes_in_group("Vivos"):
		if obj in get_tree().get_nodes_in_group("Inimigo"):
			obj.speed = speedEnemy
		elif obj in get_tree().get_nodes_in_group("Player"):
			obj.speed = speedPlayer
		else:
			obj.speed = speedProjectile
	if game_scene:
		game_scene.resume_timers()

func add_item_to_slot(item_sprite: Texture, name: String):
	for slot in slots:
		if not slot.texture:
			if name == "itemBublegum":
				game_scene.item_scenes.erase("res://itemBubblegum.tscn")
				itemBublegum = true
			if name == "itemShield":
				game_scene.item_scenes.erase("res://itemShield.tscn")
				itemShield = true
			if name == "itemBoots":
				game_scene.item_scenes.erase("res://itemBoots.tscn")
				itemBoots = true
				player.speed *= 1.25
				player.original_speed *= 1.25
			slot.texture = item_sprite
			return
	print("Todos os slots estão cheios!")

func _on_options_button_pressed() -> void:
	options_menu.show()

func _on_back_button_pressed() -> void:
	options_menu.hide()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
