extends Node2D

var player_path: NodePath = "/root/GameScene/Player"
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.load_game()
	player = get_node_or_null(player_path)
	if player:
		player.gold = GameState.gold

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause_timers():
	pass
	
func resume_timers():
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://GameScene.tscn")
