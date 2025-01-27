extends VideoStreamPlayer

func _ready():
	connect("finished", Callable(self, "_on_video_finished"))

func _process(delta: float) -> void:
	if visible == true and Input.is_action_just_pressed("ui_cancel"):
		_on_video_finished()

func _on_video_finished():
	get_tree().change_scene_to_file("res://tela_inicial.tscn")
