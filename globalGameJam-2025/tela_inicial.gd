extends Node2D

var player_path: NodePath = "/root/GameScene/Player"
var player
var label3_path = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/Label3"
var label3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.load_game()
	label3 = get_node_or_null(label3_path)
	if label3:
		label3.position.y -= 82
	player = get_node_or_null(player_path)
	if player:
		player.tela_inicial = true
		player.gold = GameState.gold
		player.emit_signal("gold_updated", player.gold)
		update_status()

func update_status() -> void:
	player.arma = GameState.arma
	player.selectWeapon()
	player.maxHealth += (player.maxHealth * 0.10) * GameState.maxHp
	player.health += (player.health * 0.10) * GameState.maxHp
	player.speed += (player.speed * 0.10) * GameState.movespeed
	player.critico += 0.10 * GameState.critico
	player.emit_signal("stats_updated")

func pause_timers():
	pass
	
func resume_timers():
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://GameScene.tscn")
