extends CharacterBody2D

var target
const SPEED = 600.0
var direction

func _ready() -> void:
	target = get_global_mouse_position()
	
func _physics_process(delta):
	position -= direction * SPEED * delta 

func _on_impact_body_entered(body):
	if body.is_in_group("Inimigo"):
		body.die()
		queue_free()
