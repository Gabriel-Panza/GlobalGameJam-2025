extends Popup

signal option_selected(option)

func _ready() -> void:
	$VBoxContainer/Button1.text = "Aumentar Velocidade"
	$VBoxContainer/Button1.connect("pressed", Callable(self, "_on_option_pressed").bind("option_1"))
	$VBoxContainer/Button2.text = "Aumentar Vida"
	$VBoxContainer/Button2.connect("pressed", Callable(self, "_on_option_pressed").bind("option_2"))
	$VBoxContainer/Button3.text = "Aumentar Dano"
	$VBoxContainer/Button3.connect("pressed", Callable(self, "_on_option_pressed").bind("option_3"))

func show_popup():
	popup_centered()
	get_tree().paused = true


func _on_option_pressed(option: Variant) -> void:
	get_tree().paused = false
	emit_signal("option_selected", option)
	hide()
