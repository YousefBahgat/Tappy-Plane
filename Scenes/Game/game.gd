extends Node


@export var pipes_scene:PackedScene
@onready var lower_spawn: Marker2D = $LowerSpawn
@onready var upper_spawn: Marker2D = $UpperSpawn
@onready var pipes_holder: Node = $PipesHolder


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("return_to_menu"):
		GameManagerScene.load_main_screen()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_pipes()


func spawn_pipes() -> void:
	var new_pipes:Pipes = pipes_scene.instantiate()
	var y_pos: float = randf_range(upper_spawn.position.y, lower_spawn.position.y)
	var x_pos: float = upper_spawn.position.x
	new_pipes.position = Vector2(x_pos,y_pos)
	pipes_holder.add_child(new_pipes)


func _on_spawning_timer_timeout() -> void:
	spawn_pipes()
