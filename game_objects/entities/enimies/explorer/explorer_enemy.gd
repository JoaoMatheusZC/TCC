extends CharacterBody2D

@export_enum("Explorer", "RAR", "Bloco de Notas", "CMD") var inimigo_1 = "Explorer"
@export var life_enemy_1 = 10
@export var damage_enemy_1 = 2

@export_enum("Explorer", "RAR", "Bloco de Notas", "CMD", "Nenhum") var inimigo_2 = "Nenhum"
@export var life_enemy_2 = 0
@export var damage_enemy_2 = 0



signal change(enemy, enemy_1_path, life_enemy_1, damage_enemy_1, enemy_2_path, life_enemy_2, damage_enemy_2)


func _ready() -> void:
	$AnimatedSprite2D.play("IDLE")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		change.emit(self, inimigo_1, life_enemy_1, damage_enemy_1, inimigo_2, life_enemy_2, damage_enemy_2)
