extends Node

@export var Game: PackedScene
@export var Main: PackedScene


func load_game_screen()->void:
	get_tree().change_scene_to_packed(Game)
	
func load_main_screen()->void:
	get_tree().change_scene_to_packed(Main)	
