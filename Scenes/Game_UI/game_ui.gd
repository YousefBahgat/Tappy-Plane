extends Control

@onready var game_over_label: Label = $MarginContainer/GameOverLabel
@onready var press_jump_label: Label = $MarginContainer/PressJumpLabel
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound
@onready var timer: Timer = $Timer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("return_to_menu"):
		GameManagerScene.load_main_screen()
	if event.is_action_pressed("fly") and press_jump_label.visible:
		GameManagerScene.load_main_screen()



func _ready() -> void:
	#connect to the signal in the signalhub
	SignalHub.Tappy_died.connect(game_over)


func game_over()-> void: 
	game_over_label.show()
	game_over_sound.play()
	timer.start()

func _on_timer_timeout() -> void:
	game_over_label.hide()
	press_jump_label.show()
