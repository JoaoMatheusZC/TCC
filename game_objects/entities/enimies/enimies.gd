extends CharacterBody2D

@export_enum("Explorer", "RAR") var inimigo_1 = "Explorer"
var enime_1_path
@export var life_enime_1 = 10
@export var damage_enime_1 = 2

@export_enum("Explorer", "RAR", "Nenhum") var inimigo_2 = "Nenhum"
var enime_2_path
@export var life_enime_2 = 0
@export var damage_enime_2 = 0


var enimes_path = {
	"Explorer": "res://game_objects/entities/enimies/explorer/explorer_enime.tscn",
	"RAR": "",
	"Nenhum": ""
}
var player_touch = false

signal change(dados)

func _ready() -> void:
	$AnimatedSprite2D.play("IDLE")
	enime_1_path = enimes_path[inimigo_1]
	enime_2_path = enimes_path[inimigo_2]

func _process(delta: float) -> void:
	if player_touch:
		if GlobalGameData.enime_death:
			GlobalGameData.enime_death = false
			player_touch = false
			queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var dados = {
		"enime_1": enime_1_path,
		"enime_1_life": life_enime_1 if life_enime_1 != null else 0,
		"enime_1_damage": damage_enime_1,
		"enime_2": enime_2_path,
		"enime_2_life": life_enime_2 if life_enime_2 != null else 0,
		"enime_2_damage": damage_enime_2,
	}
	if body.name == "Player":
		change.emit(dados)
		player_touch = true
