extends Node2D

## Position on the mapf
var map_pos:Vector2 = Vector2(-1,-1)

var zone:Zone:
	get:
		return Zone.new("squadzone",Vector2i(0,0),Vector2i(squad_zone_width-1,squad_zone_width-1))

## Flag indicating whether a squad is locked into a position on it's map
## (e.g. prevented from being repositioned by the player)
var locked_in = false

@export var squad_zone_width:int = 3
@export var squad_zone_height:int = 3

## Returns a Rect2Di starting at the given coordinate
func rect_at(pos_to_check:Vector2i):
	return Rect2i(pos_to_check,Vector2i(squad_zone_width-1,squad_zone_height-1)+pos_to_check)
