extends Node

# Variáveis globais que queremos salvar
var gold = 0
var arma = "res://projectile.tscn"
var maxHp = 0
var ataque = 0
var movespeed = 0
var atkSpeed = 0
var critico = 0
var mrBubbles = 0

var save_file_path = "user://save_data.json"

var JavaScript = JavaScriptBridge

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
	
	if OS.has_feature("web"):  # Para WebGL
		var json_data = JSON.new()
		var save_data_string = json_data.stringify(save_data)
		JavaScript.eval("localStorage.setItem('save_data', '" + save_data_string.replace("'", "\\'") + "');")
		print("Jogo salvo com sucesso no localStorage!")
	else:  # Para outras plataformas
		var file = FileAccess.open(save_file_path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(save_data))
			file.close()
			print("Jogo salvo com sucesso!")

# Função para carregar os dados
func load_game():
	if OS.has_feature("web"):  # Para WebGL
		var save_data_string = JavaScript.eval("localStorage.getItem('save_data');")
		if save_data_string != null and save_data_string != "":
			var json = JSON.new()
			var parse_result = json.parse(save_data_string)
			if parse_result:
				_apply_loaded_data(parse_result)
				print("Jogo carregado com sucesso do localStorage!")
			else:
				print("Erro ao carregar os dados do localStorage: ", parse_result.error_string)
		else:
			print("Nenhum dado encontrado no localStorage!")
	else:  # Para outras plataformas
		if FileAccess.file_exists(save_file_path):
			var file = FileAccess.open(save_file_path, FileAccess.READ)
			if file:
				var save_data_string = file.get_as_text()
				file.close()
				
				var parse_result = JSON.parse_string(save_data_string)
				if parse_result:
					_apply_loaded_data(parse_result)
					print("Jogo carregado com sucesso!")
				else:
					print("Erro ao carregar o arquivo de salvamento: ", parse_result.error_string)
		else:
			print("Nenhum arquivo de salvamento encontrado.")

# Função auxiliar para aplicar os dados carregados
func _apply_loaded_data(save_data: Dictionary) -> void:
	gold = save_data.get("gold", 0)
	arma = save_data.get("arma", "res://projectile.tscn")
	maxHp = save_data.get("maxHp", 0)
	ataque = save_data.get("ataque", 0)
	movespeed = save_data.get("movespeed", 0)
	atkSpeed = save_data.get("atkSpeed", 0)
	critico = save_data.get("critico", 0)
	mrBubbles = save_data.get("mrBubbles", 0)

# Carregar os dados ao iniciar o jogo
func _ready():
	load_game()
