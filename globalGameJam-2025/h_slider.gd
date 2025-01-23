extends HSlider

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(delta: float) -> void:
	var texto1 = $"../Volume1"
	texto1.text = var_to_str(value)
	var texto2 = $"../Volume2"
	texto2.text = var_to_str($"../HSlider2".value)
