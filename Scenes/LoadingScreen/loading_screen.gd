extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# create a timer directly in the game tree and wait for the timeout signal
	# await keyword is a non-blocking statement that tells code wait in this line for this 
	# function, but doesn't block the other scenes or code of the game..
	await get_tree().create_timer(1.0).timeout
	# after the timer finishes change to next scene..
	# GameManager.change_to_next()
