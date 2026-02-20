extends Node

signal change_back

var inimigo
var existe_dados = false

var magia = ""

var code_scene = preload("res://system/system_scenes/magic_code.tscn")
var code_scene_instance: Node

var enime_1_life = 0
var enime_2_life = 0

var damage = 0


func _ready() -> void:
	


	print(enime_1_life)
	print(enime_2_life)

func _process(delta: float) -> void:
	
	if inimigo and not existe_dados:
		existe_dados = true
		enime_1_life = inimigo.life_enime_1
		enime_2_life = inimigo.life_enime_2
		$"Enime 1/ProgressBar".set_max(enime_1_life)
		$"Enime 1/ProgressBar".set_value(enime_1_life)
		
		$"Enime 2/ProgressBar".set_max(enime_2_life)
		$"Enime 2/ProgressBar".set_value(enime_2_life)
	
	if is_instance_valid($"Enime 1"):
		$"Enime 1/ProgressBar".set_value(enime_1_life)
		if enime_1_life <= 0:
			$"Enime 1".queue_free()
	if is_instance_valid($"Enime 2"):
		$"Enime 2/ProgressBar".set_value(enime_2_life)
		if enime_2_life <= 0:
			$"Enime 2".queue_free()

	if enime_1_life <= 0 and enime_2_life <= 0:
		inimigo.queue_free()
		change_back.emit()

func Load_File():
	var path = "user://teste.txt"
	
	if FileAccess.file_exists(path):
		var arquivo = FileAccess.open(path, FileAccess.READ_WRITE)
		var conteudo = arquivo.get_as_text()
		arquivo.close()
		magia = conteudo


func _on_button_6_pressed():
	emit_signal("change_back")

func _on_button_pressed() -> void:
	Load_File()
	var process_code = Magic_Code.new()
	process_code.Terminal_Read(magia)
	damage = GlobalGameData.damage
	


func _on_button_3_pressed() -> void:
	code_scene_instance = code_scene.instantiate()
	add_child(code_scene_instance)
	code_scene_instance.back.connect(_on_code_change)
	
func _on_code_change():
	print("bbbbb")
	code_scene_instance.queue_free()


func _on_enime_select_1_pressed() -> void:
	print("a")
	enime_1_life -= damage


func _on_enime_select_2_pressed() -> void:
	print("b")
	enime_2_life -= damage
