extends Node2D

var player_path: NodePath = "/root/GameScene/Player"
var player
var camera_path: NodePath = "/root/GameScene/Player/Camera2D"
var camera
var hud_offset: Vector2 = global_position
var level_up_popup

func _ready() -> void:
	player = get_node_or_null(player_path)
	camera = get_node_or_null(camera_path)
	
	level_up_popup = preload("res://LevelUpPopup.tscn").instantiate()
	add_child(level_up_popup)
	level_up_popup.connect("option_selected", Callable(self, "_apply_effect"))
	
	if player and camera:
		# Salvar a posição inicial do HUD
		hud_offset = global_position - camera.global_position
		
		# Conecte os sinais do jogador ao HUD
		player.connect("xp_updated", Callable(self, "_on_xp_updated"))
		player.connect("level_updated", Callable(self, "_on_level_updated"))
		player.connect("level_updated", Callable(self, "_on_level_up"))
	else:
		print("Jogador ou câmera não encontrados!")

func _on_xp_updated(current_xp, xp_to_next_level) -> void:
	$ProgressBar.value = current_xp
	$ProgressBar.max_value = xp_to_next_level

func _on_level_updated(level, current_xp, xp_to_next_level) -> void:
	$Label.text = "Level: %d" % level
	$ProgressBar.value = current_xp
	$ProgressBar.max_value = xp_to_next_level

func _on_level_up(level, current_xp, xp_to_next_level):
	level_up_popup.show_popup()

func _apply_effect(option):
	match option:
		"option_1":
			player.speed += 10
		"option_2":
			player.hp += 10
		"option_3":
			player.damage += 10
