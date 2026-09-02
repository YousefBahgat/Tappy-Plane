class_name Pipes
extends Node2D


const SCROLL_SPEED: float = 120 
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scoring_sound: AudioStreamPlayer = $ScoringSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_on_screen_notifier_2d.connect("screen_exited",_onPipesScreenExit)
	
func _physics_process(delta: float) -> void:
	position.x -= SCROLL_SPEED * delta
	
func _onPipesScreenExit():
	queue_free()
	


func _on_on_screen_exit_saftey_timer_timeout() -> void:
	queue_free()
	


func _on_pipe_body_entered(body: Node2D) -> void:
	print("_on_pipe_body_entered: Name: %s \t Body entered: %s" %[name,body.name] )
	if body is Tappy : body.die()


func _on_laser_body_entered(_body: Node2D) -> void:
	scoring_sound.play()
	# add a point to the score through the scoremanager and emit the signal from the signalhub
	ScoreManager.add_point()
