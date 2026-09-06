extends Control

@onready var high_score_label: Label = $MarginContainer/HighScoreLabel

func _ready() -> void:
	get_tree().paused = false
	# Display highscore
	high_score_label.text = "%04d" % ScoreManager.highscore
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fly"):
		ComplexChange.load_game_screen()
		
		
