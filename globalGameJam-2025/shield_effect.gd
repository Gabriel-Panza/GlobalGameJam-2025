extends Area2D

@onready var open = $turn_on

func _ready() -> void:
	$AudioStreamPlayer2D.play()

func _process(delta: float) -> void:
	if !visible and open.is_stopped():
		open.start()


func _on_turn_on_timeout() -> void:
	print("voltou")
	$AudioStreamPlayer2D.play()
	visible = true 
