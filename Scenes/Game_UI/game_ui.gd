extends Control

@onready var game_over_label: Label = $MarginContainer/GameOverLabel


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("return_to_menu"):
		GameManagerScene.load_main_screen()



func _ready() -> void:
	#connect to the signal in the signalhub
	SignalHub.Tappy_died.connect(game_over)


func game_over()-> void: 
	game_over_label.show()
