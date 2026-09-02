extends Node
# the is an autoload(global) that works aside with signalhub and GameManager 
# used to manage the score, here we emit the signal from the signalhub, add a point 
# to the score and then send the new score, the UI Will then connect to the signal in 
#  signalhub and update the UI
var _score: int = 0 

# path to the file of the saved highScore...
# note: you can access the user data folder from the godot engine..
# user:// is an alias for the games's user data folder 
const SAVEPATH: String = "user://tappy_save.dat"

# this is the highscore property we gonna set it if and only if the value is greater than
# the highscore, and we gonna check for it everytime tappy dies...
# note: we removed the setter because when the game first starts it going to read 
# from the file  and set the highscore then immediately store the highscore in it again that is silly 
# so silly, so a rejig is we gonna add the condition in the on_tappy_die func
var highscore: int = 0


func _ready() -> void:
	# load the highscore from file tappy_save 
	load_from_file()
	# connect to tappy_died to check on to run through the setter and update highscore if needed
	SignalHub.Tappy_died.connect(on_tappy_died)
	

func on_tappy_died()->void:
	if _score > highscore:
		highscore = _score
		save_to_file()
	# we can also reset our score after that (when the game starts and when it ends)
	reset_score()
	
	
func add_point()-> void:
	_score+=1
	SignalHub.emit_point_scored(_score)
	
func reset_score()-> void:
	_score = 0
	
	
func save_to_file():
	var file = FileAccess.open(SAVEPATH, FileAccess.WRITE)
	if !file: 
		push_error('save_to_file no file found')
		return
	# store the value in binary endian format
	file.store_32(highscore)

func load_from_file():
	var file = FileAccess.open(SAVEPATH, FileAccess.READ)
	if !file: 
		push_error('load_from_file no file found')
		return
	highscore = file.get_32()
		
