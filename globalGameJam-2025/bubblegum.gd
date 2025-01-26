extends Node2D

var inimigos_afetados = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AnimatedSprite2D:
		if $AnimatedSprite2D.frame == 6:
			$Sprite2D.visible = true
			$AnimatedSprite2D.queue_free()
	if $Sprite2D.visible == true:
		$RichTextLabel.visible = false
		var timer = $Timer
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
				if $AnimatedSprite2D:
					$AnimatedSprite2D.visible = true
					$RichTextLabel.visible = true
					$AnimatedSprite2D.play("default") 
				target.speed = target.speed / 2
				target.get_node_or_null("bubble_effect").visible = true


func _on_timer_timeout() -> void:
	for target in inimigos_afetados:
		if target and is_instance_valid(target):
			target.speed = target.original_speed
			target.get_node_or_null("bubble_effect").visible = false
	queue_free()
