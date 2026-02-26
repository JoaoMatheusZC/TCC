extends Node

var enimes_path = {
	"Explorer": preload("res://game_objects/entities/enimies/explorer/explorer_enemy.tscn"),
	"RAR": preload("res://game_objects/entities/enimies/rar/rar_enemy.tscn"),
	"Bloco de Notas": preload("res://game_objects/entities/enimies/text/text_enemy.tscn"),
	"CMD": preload("res://game_objects/entities/enimies/cmd/cmd_enemy.tscn"),
	"Nenhum": null
}



#Valores das Magias
var damage = 0
var regen = 0

#Valores Player
var player_life
var player_max_life


#Configurações
var fullscreen:bool
var resolutions:Vector2
