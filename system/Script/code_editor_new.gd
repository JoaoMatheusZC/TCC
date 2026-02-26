extends Node
class_name Magic_Code

signal back

var texto_carregado = ""
var math_operators = ["+", "-", "/", "*"]
var cond_operators = ["==", "!=", "<", ">", "<=", ">="]
var var_memory = {}
var var_type = {}
var ifble = true

#Variaveis de propriedades que afetam diretamente o jogo
var spell_type = ""
var damage = 0
var defence = 0
var regen = 0
#Tem q zerar no começo do codigo para limpar qualquer atribução anterior de codigo ja apgado


func Terminal_Read(text:String):
	damage = 0
	defence = 0
	
	var line = text.split("\n")
	var i = 0
	
	while i < line.size():
		var words = line[i].strip_edges()
		var words_split = words.split(" ")
		
		if words == "" or words.begins_with("#"):
			i += 1
			continue
		
		if words.begins_with("var ") and ifble:
			Var_Read(line[i])
			i += 1
		
		elif words.begins_with("print(") and ifble:
			Print_Read(line[i])
			i += 1
		
		elif var_memory.has(words_split[0]) and ifble:
			Var_Verify(line[i], 0)
			i += 1
		
		elif words.begins_with("if "):
			Conditional_Read(line[i])
			i += 1
		
		elif words.begins_with("}"):
			If_Change()
			i += 1
		
		elif words.begins_with("Magia()."):
			Spell_Read(line[i])
			i += 1
		
		else:
			i += 1

# armazena as variaveis e seus valores em um dicionario(tendo como chave o nome da variavel)
# diferenciar tipos de dados(array de dicionarios, o nome do dicionario é o nome da variavel,
# 	a chave o valor da variavel e o valor seu tipo)
func Var_Read(line):
	var words = line.split(" ")
	if words[2] == "=":
		if words[3].begins_with('"') and words[3].ends_with('"'):#condicional de erro caso so tenha " no começo ou so no final
			var_memory[words[1]] = words[3]
			var_type[words[1]] = "String"
		else:
			if step_decimals(float(words[3])) == 0:
				var_memory[words[1]] = int(words[3])
				var_type[words[1]] = "Int"
			else:
				var_memory[words[1]] = float(words[3])
				var_type[words[1]] = "Float"

func Var_Verify(line, pos):
	line = line.strip_edges()
	var words = line.split(" ")
	print(words)
	print(words.size())

	if var_memory.has(words[pos]):
		if words[pos + 1] == "=":
			
			if pos == 0 and words.size() == 3:
				if !var_memory.has(words[pos+2]):
					if words[pos + 2].begins_with('"') and words[pos + 2].ends_with('"'):
						var_memory[words[pos]] = words[pos + 2]
						var_type[words[pos]] = "String"
					else:
						var_memory[words[pos]] = words[pos + 2]
						var_type[words[pos]] = "Int"
				else:
					var_memory[words[pos]] = var_memory[words[pos + 2]]
					var_type[words[pos]] = var_type[words[pos + 2]]
				
			elif pos == 0 and words.size() > 3:
				var values = []
				var operators = []
				
				for i in words.size()-2:
					
					if i % 2 == 0:
						if !var_memory.has(words[2 + i]):
							values.append(words[2 + i])
						else:
							values.append(var_memory[words[2 + i]])
					else:
						operators.append(words[2 + i])
						i += 1
				
				
				var number = Math(values, operators)
				if step_decimals(float(number)) != 0:
					var_memory[words[pos]] = float(number)
					var_type[words[pos]] = "Float"
				else:
					var_memory[words[pos]] = int(number)
					var_type[words[pos]] = "Int"

func Math(values, operators):
	
	var nums = values.map(func(v): return float(v))
	var ops = operators.duplicate()

	# Resolve * e /
	var i = 0
	while i < ops.size():
		if ops[i] == "*" or ops[i] == "/":
			var result = Calc(nums[i], nums[i + 1], ops[i])
			nums[i] = result
			nums.remove_at(i + 1)
			ops.remove_at(i)
		else:
			i += 1

	# Resolve + e -
	var total = nums[0]
	for j in range(ops.size()):
		total = Calc(total, nums[j + 1], ops[j])
	
	if step_decimals(total) == 0:
		return int(total)
	else:
		return float(total)

func Calc(a, b, operator):
	match operator:
		"+": return a + b
		"-": return a - b
		"*": return a * b
		"/": return a / b
	return 0

# printa no terminal(futuramente se continuar existindo no jogo) textos ou valores de variaveis
func Print_Read(line):
	var open_par = line.find("(")
	var close_par = line.rfind(")")
	if open_par == -1 or close_par == -1:
		return#Adicionar para por erro
	
	var text_par = line.substr(open_par + 1, close_par - open_par - 1)
	var concat = text_par.split("+")
	var output = ""
	
	for text in concat:
		text = text.strip_edges()
		
		if text.begins_with('"'):
			var text_mark = text.replace("\"", "")
			output += text_mark

		elif var_memory.has(text):
			output += (str(var_memory[text]) + var_type[text])
	
	print(output)

func Conditional_Read(line):
	var words = line.split(" ")
	var conditional_text = words.duplicate()
	conditional_text.erase("if")
	conditional_text.erase("{")
	var item1 = ""
	var item1_var = false
	var item2 = ""
	var item2_var = false
	var output = false
	
	
	
	if conditional_text[0].begins_with("\""):
		item1 = conditional_text[0].replace("\"", "")
	elif var_memory.has(conditional_text[0]):
		item1 = conditional_text[0]
		item1_var = true
	else:
		item1 = float(conditional_text[0])
		
	
	if conditional_text[2].begins_with("\""):
		item2 = conditional_text[2].replace("\"", "")
	elif var_memory.has(conditional_text[2]):
		item2 = conditional_text[2]
		item2_var = true
	else:
		item2 = float(conditional_text[2])
	
	if cond_operators.has(conditional_text[1]):
		
		if item1_var and !item2_var:
			
			if var_type[item1] in ["Int", "Float"]:
				
				if typeof(item2) in [ TYPE_INT, TYPE_FLOAT]:
					output = Comparation(float(var_memory[item1]), item2, conditional_text[1])
					
				else:
					output = false
			
			else:
				
				if typeof(item2) == TYPE_STRING:
					output = Comparation(var_memory[item1], item2, conditional_text[1])
				
				else:
					output = false
				
		elif item2_var and !item1_var:
			
			if var_type[item2] in ["Int", "Float"]:
				
				if typeof(item1) in [ TYPE_INT, TYPE_FLOAT]:
					output = Comparation(item1, float(var_memory[item2]), conditional_text[1])
				
				else:
					output = false
			
			else:
				
				if typeof(item1) == TYPE_STRING:
					output = Comparation(item1, var_memory[item2], conditional_text[1])
					
				else:
					output = false
					
		elif item1_var and item2_var:
			
			if var_type[item1] in ["Int", "Float"] and var_type[item2] in ["Int", "Float"]:
				output = Comparation(float(var_memory[item1]), float(var_memory[item2]), conditional_text[1])
			
			elif var_type[item1] == "String" and var_type[item2] == "String":
				output = Comparation(var_memory[item1], var_memory[item2], conditional_text[1])
			
			else:
				output = false
			
		elif !item1_var and !item2_var:
			
			if typeof(item1) in [TYPE_INT, TYPE_FLOAT] and typeof(item2) in [TYPE_INT, TYPE_FLOAT]:
				output = Comparation(item1, item2, conditional_text[1])
			
			elif typeof(item1) == TYPE_STRING and typeof(item2) == TYPE_STRING:
				output = Comparation(item1, item2, conditional_text[1])
			
			else:
				output = false
			
	
	ifble = output

func Comparation(a, b, operator):
	match operator:
		"==":
			if a == b:
				return true
			else:
				return false
		"!=":
			if a != b:
				return true
			else:
				return false
		"<":
			if a < b:
				return true
			else:
				return false
		">":
			if a > b:
				return true
			else:
				return false
		"<=":
			if a <= b:
				return true
			else:
				return false
		">=":
			if a >= b:
				return true
			else:
				return false
	return 0

func If_Change():
	ifble = true

func Spell_Read(line):
	var words = line.split(".")
	
	if words[0] == "Magia()":
		spell_type = "Dano"
		for i in words.size()-1:
			if words[i+1].begins_with("Dano("):
				var type_and_value_damage = words[i+1].split("(")
				type_and_value_damage[1] = type_and_value_damage[1].replace(")","")
				if var_memory.has(type_and_value_damage[1]):
					damage = var_memory[type_and_value_damage[1]]
				else:
					damage = float(type_and_value_damage[1])
				
			else:
				pass#tem q dar erro aq!!!!
		
	if words[0] == "Magia()":
		spell_type = "Defesa"
		for i in words.size()-1:
			if words[i+1].begins_with("Defesa("):
				var type_and_value_defence = words[i+1].split("(")
				type_and_value_defence[1] = type_and_value_defence[1].replace(")","")
				if var_memory.has(type_and_value_defence[1]):
					defence = var_memory[type_and_value_defence[1]]
				else:
					damage = float(type_and_value_defence[1])
			else:
				pass#tem q dar erro aq!!!!

	if words[0] == "Magia()":
		spell_type = "Cura"
		for i in words.size()-1:
			if words[i+1].begins_with("Cura("):
				var type_and_value_regen = words[i+1].split("(")
				type_and_value_regen[1] = type_and_value_regen[1].replace(")","")
				if var_memory.has(type_and_value_regen[1]):
					regen = var_memory[type_and_value_regen[1]]
				else:
					regen = float(type_and_value_regen[1])
				
			else:
				pass#tem q dar erro aq!!!!
	
	print("Damage: ")
	print(damage)
	print("Cura: ")
	print(regen)
	#print("Defence: ")
	#print(defence_type)
	GlobalGameData.damage = damage
	GlobalGameData.regen = regen


func Save_File(text,path):
	
	var arquivo = FileAccess.open(path, FileAccess.WRITE)
	if arquivo:
		arquivo.store_string(text)
		arquivo.close()
	else:
		print("Deu ruim")

func Load_File(path):
	
	if FileAccess.file_exists(path):
		var arquivo = FileAccess.open(path, FileAccess.READ_WRITE)
		var conteudo = arquivo.get_as_text()
		arquivo.close()
		$TextEdit.set_text(conteudo)
		


#Botões

func _on_back_pressed() -> void:
	back.emit()


func _on_save_magic_1_pressed() -> void:
	Terminal_Read($TextEdit.get_text())
	
	Save_File($TextEdit.get_text(), "user://Magia1.txt")

func _on_load_magic_1_pressed() -> void:
	Load_File("user://Magia1.txt")



func _on_save_magic_2_pressed() -> void:
	Terminal_Read($TextEdit.get_text())
	
	Save_File($TextEdit.get_text(), "user://Magia2.txt")


func _on_load_magic_2_pressed() -> void:
	Load_File("user://Magia2.txt")
