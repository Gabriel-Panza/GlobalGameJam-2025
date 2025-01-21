extends PopupPanel

signal option_selected(option)

func _ready() -> void:
	$Button1.text = "Aumentar Velocidade"
	$Button1.connect("pressed", Callable(self, "_on_option_pressed").bind("option_1"))
	$Button2.text = "Aumentar Vida"
	$Button2.connect("pressed", Callable(self, "_on_option_pressed").bind("option_2"))
	$Button3.text = "Aumentar Dano"
	$Button3.connect("pressed", Callable(self, "_on_option_pressed").bind("option_3"))

func show_popup():
	get_tree().paused = true
	popup_centered()


func _on_option_pressed(option: Variant) -> void:
	emit_signal("option_selected", option)
	hide()
	get_tree().paused = false
