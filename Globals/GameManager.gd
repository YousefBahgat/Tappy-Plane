extends Node

const GAME = preload("uid://ch0cbsx05k47l")
const MAIN = preload("uid://dkbkajpsuy6t8")

func load_game_screen()->void:
	get_tree().change_scene_to_packed(GAME)
	
func load_main_screen()->void:
	get_tree().change_scene_to_packed(MAIN)	
