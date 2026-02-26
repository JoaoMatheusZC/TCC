extends Node

signal change_back

var enemy

var magia = ""
var selectec = false

var code_scene = preload("res://system/system_scenes/magic_code.tscn")
var code_scene_instance: Node

var enemy_1
var enemy_1_scene
var enemy_1_life = 0
var enemy_1_damage = 0

var enemy_2
var enemy_2_scene
var enemy_2_life = 0
var enemy_2_damage = 0


var damage = 0
var regen = 0

var player_turn = true
var existe_dados = false



func _process(delta: float) -> void:

	if enemy_1 != null and enemy_2 != null and not existe_dados:
		
		if enemy_1:
			enemy_1_scene = GlobalGameData.enimes_path[enemy_1].instantiate()
			$"Enemy 1".add_child(enemy_1_scene)
			enemy_1_scene.position = Vector2(888, 104)
			enemy_1_scene.scale = Vector2(5, 5)
		if enemy_2:
			enemy_2_scene = GlobalGameData.enimes_path[enemy_2].instantiate()
			$"Enemy 2".add_child(enemy_2_scene)
			enemy_2_scene.position = Vector2(600, 104)
			enemy_2_scene.scale = Vector2(5, 5)
		
		
		$Player/ProgressBar.set_max(GlobalGameData.player_max_life)
		$Player/ProgressBar.set_value(GlobalGameData.player_life)
		
		$"Enemy 1/ProgressBar".set_max(enemy_1_life)
		$"Enemy 1/ProgressBar".set_value(enemy_1_life)
		
		$"Enemy 2/ProgressBar".set_max(enemy_2_life)
		$"Enemy 2/ProgressBar".set_value(enemy_2_life)
		
		existe_dados = true
	
	
	if is_instance_valid($Player):
		$Player/ProgressBar.set_value(GlobalGameData.player_life)

	if GlobalGameData.player_life > GlobalGameData.player_max_life:
		GlobalGameData.player_life = GlobalGameData.player_max_life

	if enemy_1_life <= 0 and enemy_2_life <= 0:
		enemy.queue_free()
		change_back.emit()


func Enemies_Damage():
	if is_instance_valid(enemy_1_scene):
		if enemy_1_life > 0:
			$"Enemy 1/ProgressBar".set_value(enemy_1_life)
		else:
			enemy_1_scene.queue_free()
			$"Enemy 1/ProgressBar".set_visible(false)
			$"Enemy 1/Enime Select 1".set_visible(false)

	
	if is_instance_valid(enemy_2_scene):
		if enemy_2_life > 0:
			$"Enemy 2/ProgressBar".set_value(enemy_2_life)
		else:
			enemy_2_scene.queue_free()
			$"Enemy 2/ProgressBar".set_visible(false)
			$"Enemy 2/Enime Select 2".set_visible(false)
	




func Load_File(path):
	
	if FileAccess.file_exists(path):
		var arquivo = FileAccess.open(path, FileAccess.READ_WRITE)
		var conteudo = arquivo.get_as_text()
		arquivo.close()
		magia = conteudo



func _on_magic_1_pressed() -> void:
	Load_File("user://Magia1.txt")
	var process_code = Magic_Code.new()
	process_code.Terminal_Read(magia)
	damage = GlobalGameData.damage
	regen = GlobalGameData.regen
	selectec = true

func _on_magic_2_pressed() -> void:
	Load_File("user://Magia2.txt")
	var process_code = Magic_Code.new()
	process_code.Terminal_Read(magia)
	damage = GlobalGameData.damage
	regen = GlobalGameData.regen
	selectec = true

func _on_grimorio_pressed() -> void:
	code_scene_instance = code_scene.instantiate()
	add_child(code_scene_instance)
	code_scene_instance.back.connect(_on_code_change)
	selectec = false
	


func _on_escape_pressed() -> void:
	emit_signal("change_back")

func _on_code_change():
	code_scene_instance.queue_free()




func _on_enime_select_1_pressed() -> void:
	if player_turn and selectec:
		enemy_1_life -= damage
		player_turn = false
		Enemies_Damage()
		await get_tree().create_timer(2.0).timeout
		Enemies_Turn()


func _on_enime_select_2_pressed() -> void:
	if player_turn and selectec:
		enemy_2_life -= damage
		player_turn = false
		Enemies_Damage()
		await get_tree().create_timer(2.0).timeout
		Enemies_Turn()





func Enemies_Turn():
	if is_instance_valid(enemy_1_scene):
		GlobalGameData.player_life -= enemy_1_damage
		await get_tree().create_timer(2.0).timeout
	if is_instance_valid(enemy_2_scene):
		GlobalGameData.player_life -= enemy_2_damage
		await get_tree().create_timer(2.0).timeout
	player_turn = true


func _on_button_pressed() -> void:
	if player_turn and selectec:
		GlobalGameData.player_life += regen
		player_turn = false
		await get_tree().create_timer(2.0).timeout
		Enemies_Turn()
