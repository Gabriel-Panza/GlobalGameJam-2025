extends CharacterBody2D


var target
var speed: float = 600.0
var direction

var player_path: NodePath = "/root/GameScene/Player"
var player

func _ready() -> void:
	player = get_node_or_null(player_path)
	target = get_global_mouse_position()
	
func _physics_process(delta):
	position -= direction * speed * delta 
	if speed == 0:
		queue_free()

func _on_impact_body_entered(body):
	if body.is_in_group("Inimigo"):
		if randf_range(0,1) <= player.critico:
			body.take_damage(player.ataque*2)
		else:
			body.take_damage(player.ataque)
		queue_free()
