extends Node2D

var pewpewer = preload("res://scenes/pewpewer/pewpewer.tscn")


func _ready():
	var battlers = Global.generate_five_v_five()
