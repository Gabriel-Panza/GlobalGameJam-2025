extends Area2D

var value: int = 20
var type
func _ready():
	type = name
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		body.collect_item(value, type)
		queue_free()
