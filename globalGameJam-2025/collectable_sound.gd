extends AudioStreamPlayer2D

var initial_volume = -5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = initial_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
