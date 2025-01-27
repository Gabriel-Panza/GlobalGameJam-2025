extends CharacterBody2D

var target
var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO

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
			var popup = Sprite2D.new()
			popup.visible = true
			popup.position = body.position - Vector2(75, 50)
			popup.texture = load("res://Crit Ballons/POW!.png")
			popup.scale *= 3
			popup.add_to_group("Popup")
			get_parent().add_child(popup)
			await get_tree().create_timer(0.5).timeout
			for obj in get_tree().get_nodes_in_group("Popup"):
				obj.queue_free()
		else:
			if is_instance_valid(body):
				body.take_damage(player.ataque)
	if body and is_instance_valid(body) and body.is_in_group("Limites"):
		queue_free()
