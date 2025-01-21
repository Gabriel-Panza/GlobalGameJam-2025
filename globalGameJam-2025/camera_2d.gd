extends Camera2D

# Define os limites da câmera
@export var limitLeft: int = 0
@export var limitTop: int = 0
@export var limitRight: int = 1200
@export var limitBottom: int = 0

func _ready() -> void:
	limit_left = limitLeft
	limit_top = limitTop
	limit_right = limitRight
	limit_bottom = limitBottom
	enabled = true
