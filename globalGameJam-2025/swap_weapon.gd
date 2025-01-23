extends CharacterBody2D

var player
var player_path: NodePath = "/root/GameScene/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node_or_null(player_path)

func _on_weapon_area_body_entered(body):
	if body == player:
		match name:
			"BubbleGun":
				player.arma = "res://projectile.tscn"
			"ExplubbleBomb":
				player.arma = "res://bomb.tscn"
			"SoapGauntlet":
				player.arma = "res://punch.tscn"
		player.selectWeapon()
