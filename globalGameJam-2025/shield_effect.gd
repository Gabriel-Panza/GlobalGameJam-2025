extends Area2D

@onready var open = $turn_on

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible and open.is_stopped():
		open.start()


func _on_turn_on_timeout() -> void:
	print("voltou")
	visible = true 
