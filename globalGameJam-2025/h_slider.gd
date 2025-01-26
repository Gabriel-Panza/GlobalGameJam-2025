extends HSlider

func _on_return_pressed() -> void:
	$"..".visible = false

func _process(delta: float) -> void:
	var texto1 = $"../Volume1"
	texto1.text = var_to_str(value)
	var texto2 = $"../Volume2"
	texto2.text = var_to_str($"../HSlider2".value)


func _on_value_changed(value: float) -> void:
	var musica = get_parent().get_parent().get_node_or_null("AudioStreamPlayer2D")
	musica.set_volume_db(value)
	
