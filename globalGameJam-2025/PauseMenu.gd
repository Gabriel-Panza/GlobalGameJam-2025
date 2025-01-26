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
var shield_timer: Timer


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
	itemShield = false
	itemBoots = false
	
	shield_timer = get_node_or_null("shield_timer")
	shield_timer.name = "Escudo"
	shield_timer.connect("timeout", Callable(self, "on_timeout_shield"))
	#shield_timer.set_paused(true)
	
	player.connect("stats_updated", Callable(self, "update_status_labels"))
	
func _process(delta):
	if player.speed > 0:
		if Input.is_action_just_pressed("ui_cancel"):
			if not pause_menu.is_visible():
				_pause_game()

func create_shield():
	if itemShield:
		var shield = load("res://shield_effect.tscn").instantiate()
		shield.name = "Shield"
		shield.z_index = 2
		shield.position = Vector2.ZERO
		shield_timer.set_paused(true)  # Pausar o intervalo enquanto o escudo está ativo
		player.add_child(shield)

func on_timeout_shield() -> void:
	create_shield()

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

func _on_options_button_pressed() -> void:
	options_menu.show()

func _on_back_button_pressed() -> void:
	options_menu.hide()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_hub_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tela_inicial.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	var music = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Music")
	music.set_volume_db(value)
	
	
