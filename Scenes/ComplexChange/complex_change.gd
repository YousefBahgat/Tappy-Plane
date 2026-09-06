extends CanvasLayer

@export var Game: PackedScene 
@export var Main: PackedScene 
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var _next_scene: PackedScene

func change_to_next()-> void:
	get_tree().change_scene_to_packed(_next_scene)


func start_transition(next_scene: PackedScene)->void:
	_next_scene = next_scene
	animation_player.play("fade")
	

func load_game_screen()->void:
	start_transition(Game)
	
func load_main_screen()->void:
	start_transition(Main)
