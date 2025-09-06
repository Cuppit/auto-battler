extends Node2D
## This scene manages a battle as it unfolds. 

var pewpewer = preload("res://scenes/pewpewer/pewpewer.tscn")
var pewpewer_squad = preload("res://scenes/squad/inherited/pewpewer_squad.tscn")

var team1_field:Zone
var team2_field:Zone

var zone_manager = ZoneManager.new()



@onready var timer = $Timer
@onready var floor = $Floor
@onready var debug_label = $DebugLabel
@onready var player_camera = $PlayerCamera

@onready var btn_start_battle = $btnStartBattle


func _ready():
	
	team1_field = Zone.new("team1_field", Vector2i(1,1), Vector2i(35,39))
	team2_field = Zone.new("team2_field", Vector2i(36,1), Vector2i(70,39))
	
	#zone_manager.add_zone("team1_field", Vector2i(1,1), Vector2i(35,39))
	#zone_manager.add_zone("team2_field", Vector2i(36,1), Vector2i(70,39))
	
	
	
	var battlers:Array = Global.generate_five_v_five()
	for battler in battlers:
		battler.z_index = floor.z_index + 1
		
		battler.clicked.connect(unit_clicked_on)


func _on_timer_timeout():
	if floor.visible:
		floor.visible = false
	else:
		floor.visible = true
	timer.start()


func unit_clicked_on(unit):
	player_camera.display_unit_stats(unit)


func add_test_squad():
	var test_squad = pewpewer_squad.instantiate()
	# Find a spot closest to the center of the map where the squad 
	# would fit
	# 	-get center of the map
	#	-search for 
	
	add_child(test_squad)
	


func _on_btn_start_battle_pressed():
	Global.battle_is_active = true
	btn_start_battle.visible = false


func _on_btn_add_squad_pressed():
	## Adds
	add_test_squad()
