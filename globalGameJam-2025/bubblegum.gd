extends Node2D

var inimigos_afetados = []
var animatedSprite
var sprite
var label
var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite = get_node_or_null("AnimatedSprite2D") 
	sprite = get_node_or_null("Sprite2D") 
	label = get_node_or_null("RichTextLabel") 
	timer = get_node_or_null("Timer") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animatedSprite:
		if is_instance_valid(animatedSprite) and animatedSprite.frame == 6:
			sprite.visible = true
			animatedSprite.queue_free()
	if sprite.visible == true:
		label.visible = false
		var timer = timer
		if timer.is_stopped():
			timer.start()

func _on_impact_body_entered(body: Node2D) -> void:
	var area = get_node_or_null("Impact")
	if area:
		for target in area.get_overlapping_bodies():
			print(target)
			inimigos_afetados.append(target)
			if target.is_in_group("Inimigo"):
				if is_instance_valid(animatedSprite) and animatedSprite:
					animatedSprite.visible = true
					label.visible = true
					animatedSprite.play("default") 
				target.speed = target.speed / 2
				target.get_node_or_null("bubble_effect").visible = true


func _on_timer_timeout() -> void:
	for target in inimigos_afetados:
		if target and is_instance_valid(target):
			target.speed = target.original_speed
			target.get_node_or_null("bubble_effect").visible = false
	queue_free()
