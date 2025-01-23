extends HSlider

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var texto = get_child(0)
	texto.text = var_to_str(value)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
