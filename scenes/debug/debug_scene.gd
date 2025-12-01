extends Node2D

var squad = preload("res://scenes/squad/squad.tscn")


func _ready():
	var somesquad = squad.instantiate()
	add_child(somesquad)
	somesquad.position = Vector2i(256.0, 256.0)
	print("Position of somesquad: ",somesquad.position)
