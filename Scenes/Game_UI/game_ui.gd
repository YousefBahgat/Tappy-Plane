extends Control

@onready var game_over_label: Label = $MarginContainer/GameOverLabel
@onready var press_jump_label: Label = $MarginContainer/PressJumpLabel
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound
@onready var timer: Timer = $Timer
@onready var score_label: Label = $MarginContainer/ScoreLabel




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("return_to_menu"):
		ComplexChange.load_main_screen()
	if event.is_action_pressed("fly") and press_jump_label.visible:
		score_label.hide()
		game_over_label.hide()
		ComplexChange.load_main_screen()
		



func _ready() -> void:
	#connect to the signal in the signalhub
	SignalHub.Tappy_died.connect(on_game_over)
	SignalHub.Point_scored.connect(update_the_score_label)
	# to make sure that the text placeholder is correct with 0000 when the game start
	update_the_score_label(0)

func on_game_over()-> void: 
	game_over_label.show()
	game_over_sound.play()
	timer.start()

func _on_timer_timeout() -> void:
	game_over_label.hide()
	press_jump_label.show()

func update_the_score_label(score: int) -> void: 
	score_label.text = "%04d" % score
	
