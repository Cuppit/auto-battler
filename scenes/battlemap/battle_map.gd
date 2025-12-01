extends Node2D
## This scene manages a battle as it unfolds. 

var pewpewer = preload("res://scenes/pewpewer/pewpewer.tscn")
var squad = preload("res://scenes/squad/squad.tscn")
var pewpewer_squad = preload("res://scenes/squad/inherited/pewpewer_squad.tscn")

## Each team squad array holds the list of squads that exist on that
## respective team.

var test_squad


var team1_squads:Array = []
var team2_squads:Array = []


## The zone representing the whole map.
var map_zone:Zone
var team1_field:Zone
var team2_field:Zone

# var zone_manager = ZoneManager.new()

## Used in algorithm for adding squads to a team's army
enum CurrDirection {EAST,NORTH,WEST,SOUTH,}


@onready var timer = $Timer
@onready var floor = $Floor
@onready var debug_label = $DebugLabel
@onready var player_camera = $PlayerCamera

@onready var btn_start_battle = $btnStartBattle


func _ready():
	#test_squad = squad.instantiate()
	## Ensure instance exists as a child of the map scene
	#add_child(test_squad)
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


## Reposition/redraw 
func refresh_squad_positions():
	for squad in team1_squads:
		#squad.position = team1_squads[squad]
		squad.position = Vector2i(squad.map_pos.x*Global.CELL_PX_SIZE, squad.map_pos.y*Global.CELL_PX_SIZE)
		print("Squad ",squad," position after refreshing squad positions:",squad.position)
		

func unit_clicked_on(unit):
	player_camera.display_unit_stats(unit)


func add_test_squad():
	test_squad = squad.instantiate()
	## Ensure instance exists as a child of the map scene
	add_child(test_squad)
	
	## adds the squad to the respective team
	add_squad(test_squad)
	
	
## Adds squadron "toadd" to the field
func add_squad(toadd):
	var curr_dir = CurrDirection.EAST
		
	## First, get the center of the zone we're trying to place inside of
	var mid_x = int(team1_field.bottom_right.x/2)
	var mid_y = int(team1_field.bottom_right.y/2)
	
	## Next, get the center of the zone of the squad that's being placed
	var sq_mid_x = int(toadd.squad_zone_width/2)
	var sq_mid_y = int(toadd.squad_zone_height/2)
	
	## Use this to calculate the starting point
	var pt_x = mid_x - sq_mid_x
	var pt_y = mid_y - sq_mid_y
	print("Starting point in searching for place to put squad:",pt_x,",",pt_y)
	var curr_rect 
	## Iterate over every squad currently present on the team, and check if there's
	## any overlap.  If there is, adjust current starting point, and try again.
	
	## How much to increment per step when searching in a spiral direction
	var inc_val = 1
	var steps_to_turn = 1
	
	var still_searching=true
	
	if len(team1_squads)==0:
		print("Found a spot, GONNA ADD THE SQUAD!")
		still_searching=false
		toadd.map_pos = Vector2(pt_x, pt_y)
		team1_squads.append(toadd)
		#team1_squads[toadd]=Vector2i(pt_x,pt_y)
		print("Squad position after adding:(",toadd.position.x,",",toadd.position.y,")")
		print("Total squads on this team: ",len(team1_squads))
	
	while pt_x>=0 and pt_x<team1_field.bottom_right.x and pt_y>=0 and pt_y<team1_field.bottom_right.y and still_searching:
		curr_rect = Rect2i(Vector2i(pt_x,pt_y),Vector2i(pt_x+toadd.squad_zone_width,pt_y+toadd.squad_zone_height))
		still_searching=false
		for squad in team1_squads:
			if curr_rect.intersects(squad.rect_at(Vector2i(pt_x,pt_y))):
				still_searching=true
				print("can't place at ",Vector2i(pt_x,pt_y),", finding different spot:")
				## can't place here, find a different spot
				if curr_dir == CurrDirection.EAST:
					pt_x+=1
				elif curr_dir == CurrDirection.NORTH:
					pt_y-=1
				elif curr_dir == CurrDirection.WEST:
					pt_x-=1
				elif curr_dir == CurrDirection.SOUTH:
					pt_y+=1
				
				inc_val -= 1
				if inc_val <= 0:
					steps_to_turn+=1
					inc_val=steps_to_turn
					if curr_dir == CurrDirection.EAST:
						CurrDirection.NORTH
					elif curr_dir == CurrDirection.NORTH:
						CurrDirection.WEST
					elif curr_dir == CurrDirection.WEST:
						CurrDirection.SOUTH
					elif curr_dir == CurrDirection.SOUTH:
						CurrDirection.EAST
					
				break
		if not still_searching:
			print("Found a spot, GONNA ADD THE SQUAD!")
			still_searching=false
			toadd.map_pos = Vector2i(pt_x,pt_y)
			team1_squads.append(toadd)
			print("Squad position after adding:(",toadd.position.x,",",toadd.position.y,")")
			print("Total squads on this team: ",len(team1_squads))
	refresh_squad_positions()


func _on_btn_start_battle_pressed():
	Global.battle_is_active = true
	btn_start_battle.visible = false


func _on_btn_add_squad_pressed():
	add_test_squad()
