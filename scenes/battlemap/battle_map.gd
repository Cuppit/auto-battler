extends Node2D

@onready var timer = $Timer
@onready var floor = $Floor
@onready var debug_label = $DebugLabel

var pewpewer = preload("res://scenes/pewpewer/pewpewer.tscn")

func _ready():
	var battlers:Array = Global.generate_five_v_five()
	for battler in battlers:
		battler.z_index = floor.z_index + 1


func _on_timer_timeout():
	if floor.visible:
		floor.visible = false
	else:
		floor.visible = true
	timer.start()
