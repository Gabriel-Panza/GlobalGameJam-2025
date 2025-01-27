extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(2) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		queue_free()
	await get_tree().create_timer(2.25).timeout
	queue_free()
