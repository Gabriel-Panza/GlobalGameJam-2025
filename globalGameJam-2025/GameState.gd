extends Node

# Variáveis globais que queremos salvar
var gold
var arma
var maxHp
var ataque
var movespeed
var atkSpeed
var critico
var mrBubbles

var save_file_path = "res://save_data.json"

# Função para salvar os dados
func save_game():
	var save_data = {
		"gold": gold,
		"arma": arma,
		"maxHp": maxHp,
		"ataque": ataque,
		"movespeed": movespeed,
		"atkSpeed": atkSpeed,
		"critico": critico,
		"mrBubbles": mrBubbles
	}
	
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Jogo salvo com sucesso!")

# Função para carregar os dados
func load_game():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		if file:
			var save_data = JSON.parse_string(file.get_as_text())
			file.close()
			
			if save_data:
				gold = save_data.get("gold", 0)
				arma = save_data.get("arma", "res://projectile.tscn")
				maxHp = save_data.get("maxHp", 0)
				ataque = save_data.get("ataque", 0)
				movespeed = save_data.get("movespeed", 0)
				atkSpeed = save_data.get("atkSpeed", 0)
				critico = save_data.get("critico", 0)
				mrBubbles = save_data.get("mrBubbles", 0)
				print("Jogo carregado com sucesso!")
			else:
				print("Erro ao carregar o arquivo de salvamento:")
