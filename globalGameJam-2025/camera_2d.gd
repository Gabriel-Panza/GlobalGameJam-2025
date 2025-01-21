extends Camera2D

# Define os limites da câmera
@export var limitLeft: int = 0
@export var limitTop: int = 0
@export var limitRight: int = $"../../Sprite2D".texture.get_width()
@export var limitBottom: int = $"../../Sprite2D".texture.get_height()

func _ready() -> void:
	limit_left = limitLeft
	limit_top = limitTop
	limit_right = limitRight
	limit_bottom = limitBottom
	
	enabled = true

func _process(delta: float) -> void:
	pass
