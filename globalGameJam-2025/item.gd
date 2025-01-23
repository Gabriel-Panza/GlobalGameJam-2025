extends Area2D

var value: int = 20

var pause_control_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl"
var pause_control: Control

@onready var sprite = $Sprite2D

func _ready():
	pause_control = get_node_or_null(pause_control_path)
	connect("body_entered", Callable(self, "_on_body_entered"))
	add_to_group("Escudo")

func _on_body_entered(body):
	if body.name == "Player":
		if name == "itemXP" or name == "itemHP" or name == "itemGold":
			body.collect_item(value, name)
		if name == "itemBublegum" or name == "itemShield" or name == "itemBoots":
			if pause_control:
				pause_control.add_item_to_slot(sprite.texture, name)
		queue_free()
