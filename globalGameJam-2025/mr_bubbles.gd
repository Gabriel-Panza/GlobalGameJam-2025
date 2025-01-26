extends Area2D

# Referência ao Player
var game_scene_path: NodePath = "/root/GameScene"
var game_scene
var player_path: NodePath = "/root/GameScene/Player"
var player
var player_speed: float
var pause_control_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl"
var pause_control: Control
var mrBubblesShop_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface"
var mrBubblesShop: Panel
var mrBubblesContainer_path: NodePath = "/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3"
var mrBubblesContainer: MarginContainer

var item1: Label
var item2: Label
var item3: Label
var item4: Label
var item5: Label
var item6: Label

# Preços dos itens
const ITEM_PRICES = {
	"item1": 200,
	"item2": 500,
	"item3": 500,
	"item4": 500,
	"item5": 200,
	"item6": 100000
}

func _ready():
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
	game_scene = get_node_or_null(game_scene_path)
	player = get_node_or_null(player_path)
	if player:
		player_speed = player.speed
	pause_control = get_node_or_null(pause_control_path)
	mrBubblesShop = get_node_or_null(mrBubblesShop_path)
	mrBubblesContainer = get_node_or_null(mrBubblesContainer_path)
	
	item1 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer/item1/item1_1")
	item2 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer/item2/item2_1")
	item3 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer/item3/item3_1")
	item4 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer2/item4/item1_2")
	item5 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer2/item5/item2_2")
	item6 = get_node_or_null("/root/GameScene/Player/Camera2D/CanvasLayer/HUD/PauseControl/MrBubbleInterface/MarginContainer3/VBoxContainer/HBoxContainer2/item6/item3_2")

# Função chamada quando o jogador interage com a loja
func interact_with_shop(item_name: String):
	if item_name in ITEM_PRICES:
		if (item_name == "item1" and GameState.maxHp<5) or (item_name == "item2" and GameState.ataque<5) or (item_name == "item3" and GameState.movespeed<3) or (item_name == "item4" and GameState.atkSpeed<5) or (item_name == "item5" and GameState.critico<5) or (item_name == "item6" and GameState.mrBubbles<1):
			if player.gold >= ITEM_PRICES[item_name]:
				player.gold -= ITEM_PRICES[item_name]
				GameState.gold = player.gold
				give_buff_to_player(item_name)
				player.emit_signal("gold_updated", player.gold)
			else:
				print("Você não tem ouro suficiente!")
		else:
			print("Você já evoluiu 5 vezes este status!")
	else:
		print("Item inválido!")

# Dá o item para o jogador
func give_buff_to_player(item_name: String):
	print("Você comprou:", item_name)
	if item_name == "item1":
		GameState.maxHp += 1
		item1.text = "              Quant.: %d" % (5-GameState.maxHp)
	elif item_name == "item2":
		GameState.ataque += 1
		item2.text = "              Quant.: %d" % (5-GameState.ataque)
	elif item_name == "item3":
		GameState.movespeed += 1
		item3.text = "              Quant.: %d" % (3-GameState.movespeed)
	elif item_name == "item4":
		GameState.atkSpeed += 1
		item4.text = "              Quant.: %d" % (5-GameState.atkSpeed)
	elif item_name == "item5":
		GameState.critico += 1
		item5.text = "              Quant.: %d" % (5-GameState.critico)
	elif item_name == "item6":
		GameState.mrBubbles += 1
		item6.text = "              Quant.: %d" % (1-GameState.mrBubbles)
	player.emit_signal("stats_updated")


# Detecta a entrada do jogador na loja
func _on_Area2D_body_entered(body):
	if body == player:
		print("Bem-vindo à loja do Mr. Bubbles! Selecione um item para comprar.")
		player.speed = 0
		item1.text = "              Quant.: %d" % (5-GameState.maxHp)
		item2.text = "              Quant.: %d" % (5-GameState.ataque)
		item3.text = "              Quant.: %d" % (3-GameState.movespeed)
		item4.text = "              Quant.: %d" % (5-GameState.atkSpeed)
		item5.text = "              Quant.: %d" % (5-GameState.critico)
		item6.text = "              Quant.: %d" % (1-GameState.mrBubbles)
		mrBubblesShop.show()

func _on_leave_button_pressed() -> void:
	mrBubblesShop.hide()
	player.speed = player_speed
	GameState.save_game()
	game_scene.update_status()

func _on_item1_button_pressed() -> void:
	interact_with_shop("item1")

func _on_item2_button_pressed() -> void:
	interact_with_shop("item2")

func _on_item3_button_pressed() -> void:
	interact_with_shop("item3")
