extends Node

const BASE_MAP_WIDTH = 1152
const BASE_MAP_HEIGHT = 648

## The tiles this game uses are 16x16 pixels, so actual/graphical positions
## of units during placement use this when figuring out "true" location
## on the game map
const CELL_PX_SIZE=16


## Flag units check in _process() method to determine if they should
## be acting or not
var battle_is_active = false

var pewpewer = preload("res://scenes/pewpewer/pewpewer.tscn")

var rng = RandomNumberGenerator.new()

## Debug function.  Returns a list containing all the pewpewers spawned.
func generate_five_v_five():
	var toreturn = []
	get_viewport().size.x
	get_viewport().size.y
	var next_pewpewer
	for x in range(10):
		next_pewpewer = pewpewer.instantiate()
		add_child(next_pewpewer)
		toreturn.append(next_pewpewer)
		print("current texture: ",next_pewpewer.get_sprite().texture)
		if Global.rng.randi_range(0,1) == 0:
			next_pewpewer.initialize("Team1")
			next_pewpewer.position.x = Global.rng.randi_range(0,get_viewport().size.x/2)
		else:
			next_pewpewer.initialize("Team2")
			next_pewpewer.position.x = Global.rng.randi_range(get_viewport().size.x/2,get_viewport().size.x)
		next_pewpewer.position.y = Global.rng.randi_range(0,get_viewport().size.y)
	return toreturn
