extends CharacterBody2D


const JUMP_FORCE: float = -350.0
var _gravity:float = ProjectSettings.get("physics/2d/default_gravity")
var _jumped:bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fly"):
		_jumped = true

func _physics_process(delta: float) -> void:
	# because we falling down the screen so the tappy is accelerated down the screen
	# so the velocity.y is going to increase and increase and increase every single frame 
	velocity.y += _gravity *delta
	if _jumped:
		velocity.y = JUMP_FORCE 
		_jumped = false
	# we telling our physics server to take control and calculate where we are going 
	# what is the speed and position, and the actual velocity..
	# Note: if its not an acceleration ...and its a constant velocity we don't multiply by delta
	# because the move and slide func takes into consideration the timestamp (delta) ..so it multiples by delta
	move_and_slide()
	
	
