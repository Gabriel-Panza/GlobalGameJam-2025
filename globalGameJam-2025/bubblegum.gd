extends Node2D

var inimigos_afetados = []
var animatedSprite = get_node_or_null("AnimatedSprite2D")
var sprite

func _ready() -> void:
	sprite = get_node_or_null("Sprite2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animatedSprite:
		if animatedSprite.frame == 6:
			animatedSprite.queue_free()
	if sprite.visible == true:
		var timer = get_node_or_null("Timer")
		if timer.is_stopped():
			timer.start()

func _on_impact_body_entered(body: Node2D) -> void:
	var area = get_node_or_null("Impact")
	if area:
		for target in area.get_overlapping_bodies():
			print(target)
			inimigos_afetados.append(target)
			if target.is_in_group("Inimigo"):
				print(target)
				if animatedSprite:
					animatedSprite.visible = false
					animatedSprite.play("default")
				sprite.visible = true 
				target.speed = target.speed / 2
				target.get_node_or_null("bubble_effect").visible = true


func _on_timer_timeout() -> void:
	for target in inimigos_afetados:
		if target and is_instance_valid(target):
			target.speed = target.original_speed
			target.get_node_or_null("bubble_effect").visible = false
	queue_free()
