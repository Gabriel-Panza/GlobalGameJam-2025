extends Panel

var game_scene_path: NodePath = "/root/GameScene"
var game_scene
var pause_menu_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseMenu"
var pause_menu
var speedPlayer
var speedEnemy
var speedProjectile

func _ready() -> void:
	game_scene = get_node_or_null(game_scene_path)
	pause_menu = get_node_or_null(pause_menu_path)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if pause_menu.is_visible():
			_unpause_game()
		else:
			_pause_game()

func _pause_game():
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
