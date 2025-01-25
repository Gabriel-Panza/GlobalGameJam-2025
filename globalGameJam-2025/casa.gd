extends Area2D


# Referência ao Player
var player_path: NodePath = "/root/GameScene/Player"
var player

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	player = get_node_or_null(player_path)

# Detecta a entrada do jogador na casa
func _on_Area2D_body_entered(body):
	if body == player:
		get_tree().change_scene_to_file("res://main_menu.tscn")
