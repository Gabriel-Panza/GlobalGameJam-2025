extends Node

# Variáveis globais que queremos salvar
var gold
var arma

var save_file_path = "user://save_data.json"

# Função para salvar os dados
func save_game():
	var save_data = {
		"gold": gold,
		"arma": arma,
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
				print("Jogo carregado com sucesso!")
			else:
				print("Erro ao carregar o arquivo de salvamento:")
