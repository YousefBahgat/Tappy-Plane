extends Control


func _ready() -> void:
	get_tree().paused = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fly"):
		GameManagerScene.load_game_screen()
		
