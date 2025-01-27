extends Area2D

var value: int = 15

var pause_control_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl"
var pause_control: Control
var player_path: NodePath = "/root/GameScene/Player"
var player

var sprite

func _ready():
	player = get_node_or_null(player_path)
	sprite = get_node_or_null("Sprite2D")
	pause_control = get_node_or_null(pause_control_path)
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		if is_in_group("XP"):
			_process_xp_item()
		elif is_in_group("bigXP"):
			_process_big_xp_item()
			
		elif is_in_group("HP"):
			_process_hp_item()
		elif is_in_group("Gold"):
			_process_gold_item()
		elif is_in_group("Acessorios"):
			_process_equipment_item()
	queue_free()

func _process_xp_item():
	if player:
		var som = player.get_node_or_null("Collectable_Sound")
		som.stream = load("res://SFX/XP_Pickup.mp3")
		som.add_to_group("SFX")
		#som.volume_db = 24
		som.play()
		player.gain_xp(value * 2)

func _process_big_xp_item():
	if player:
		var som = player.get_node_or_null("Collectable_Sound")
		som.stream = load("res://SFX/XP_Pickup.mp3")
		som.add_to_group("SFX")
		#som.volume_db = 24
		som.play()
		player.gain_xp(value * 5)
		
func _process_hp_item():
	if player:
		var som = player.get_node_or_null("Collectable_Sound")
		som.stream = load("res://SFX/POP_Soda_Gulp.mp3")
		som.add_to_group("SFX")
		#som.volume_db = -1	
		som.play()
		if player.health + value <= player.maxHealth:
			player.health += (value + 5)
		else:
			player.health = player.maxHealth
		player.emit_signal("hp_updated", player.health, player.maxHealth)
		player.emit_signal("stats_updated")
	
func _process_gold_item():
	if player:
		var som = player.get_node_or_null("Collectable_Sound")
		som.stream = load("res://SFX/Gold_Pickup.mp3")
		som.add_to_group("SFX")
		#som.volume_db = -1
		som.play()
		player.gold += value*2
		player.emit_signal("gold_updated", player.gold)

func _process_equipment_item():
	for slot in pause_control.slots:
		if not slot.texture:
			if name == "itemBublegum":
				pause_control.game_scene.item_scenes.erase("res://itemBubblegum.tscn")
				pause_control.itemBublegum = true
			elif name == "itemShield":
				pause_control.game_scene.item_scenes.erase("res://itemShield.tscn")
				pause_control.itemShield = true
				pause_control.shield_timer.set_paused(false)
			elif name == "itemBoots":
				pause_control.game_scene.item_scenes.erase("res://itemBoots.tscn")
				pause_control.itemBoots = true
				player.speed *= 1.25
				player.original_speed *= 1.25
			slot.texture = sprite.texture
			break
