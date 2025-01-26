extends Panel

var game_scene_path: NodePath = "/root/GameScene"
var game_scene
var speedPlayer
var speedEnemy
var speedProjectile
var options = [
	{ "id": "option_1", "text": "Speed Up", "icon": "res://sprites/StatsUp/mvspeed_up_texture.tres" },
	{ "id": "option_2", "text": "Health Up", "icon": "res://sprites/StatsUp/Hp_up_texture.tres" },
	{ "id": "option_3", "text": "Attack Up", "icon": "res://sprites/StatsUp/atk_up_texture.tres" },
	{ "id": "option_4", "text": "Crit-Rate Up", "icon": "res://sprites/StatsUp/crit_up_texture.tres" },
	{ "id": "option_5", "text": "Atk-Speed Up", "icon": "res://sprites/StatsUp/speed_up_texture.tres" }
]

signal option_selected(option)

func _ready() -> void:
	game_scene = get_node_or_null(game_scene_path)
	visible = false

func show_popup():
	# Randomiza 3 opções do vetor de opções
	options.shuffle()
	visible = true 
	var randomized_options = options.slice(0, 3)
	
	# Atualiza os botões com as opções randomizadas
	for i in range(3):
		var button = $VBoxContainer.get_child(i)
		button.text = randomized_options[i]["text"]
		button.set_button_icon(load(randomized_options[i]["icon"]))
		button.disconnect("pressed", Callable(self, "_on_option_pressed"))
		button.connect("pressed", Callable(self, "_on_option_pressed").bind(randomized_options[i]["id"]))

	if game_scene:
		game_scene.pause_timers()
	for obj in get_tree().get_nodes_in_group("Vivos"):
		if obj in get_tree().get_nodes_in_group("Inimigo"):
			speedEnemy = obj.speed
		elif obj in get_tree().get_nodes_in_group("Player"):
			speedPlayer = obj.speed
		else:
			speedProjectile = obj.speed
		obj.speed = 0

func _on_option_pressed(option: Variant) -> void:
	$menu_click.play()
	for obj in get_tree().get_nodes_in_group("Vivos"):
		if obj in get_tree().get_nodes_in_group("Inimigo"):
			obj.speed = speedEnemy
		elif obj in get_tree().get_nodes_in_group("Player"):
			obj.speed = speedPlayer
		else:
			obj.speed = speedProjectile
	if game_scene:
		game_scene.resume_timers()
	emit_signal("option_selected", option)
	hide()
