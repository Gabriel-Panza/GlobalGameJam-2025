extends Area2D

# Referência ao Player e ao Gold do jogo
var player_path: NodePath = "/root/GameScene/Player"
var player

# Preços dos itens
const ITEM_PRICES = {
	"item1": 50,
	"item2": 100,
	"item3": 150
}

# Itens disponíveis na loja
@onready var items = {
	"item1": $BubbleGun,
	"item2": $ExplubbleBomb,
	"item3": $SoapGauntlet
}

func _ready():
	player = get_node_or_null(player_path)

# Função chamada quando o jogador interage com a loja
func interact_with_shop(item_name: String):
	if item_name in ITEM_PRICES:
		if player.gold >= ITEM_PRICES[item_name]:
			player.gold -= ITEM_PRICES[item_name]
			give_item_to_player(item_name)
		else:
			print("Você não tem ouro suficiente!")
	else:
		print("Item inválido!")

# Dá o item para o jogador
func give_item_to_player(item_name: String):
	print("Você comprou:", item_name)
	# Adicionar item ao player

# Detecta a entrada do jogador na loja
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		print("Bem-vindo à loja do Mr. Bubbles! Selecione um item para comprar.")

# Detecta a saída do jogador da loja
func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		print("Volte sempre!")
