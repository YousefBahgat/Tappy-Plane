extends Node

signal Tappy_died
signal Point_scored(score: int)


func emit_tappy_died()->void: 
	Tappy_died.emit()

func  emit_point_scored(score: int)->void: 
	Point_scored.emit(score)
