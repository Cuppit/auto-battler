class_name Zone
extends Resource

## The zones will be the data representation of the maps, as well as the 
## squad spaces.  The tileset used in this game has 16x16 pixel cells.  So,
## CELL_PX_SIZE will be used when calculating graphical representations
## later.


const CELL_PX_SIZE=16

@export var name: String
@export var top_left: Vector2i
@export var bottom_right: Vector2i


func _init(name:String, topleft:Vector2i, bottomright:Vector2i):
	top_left = topleft
	bottom_right = bottomright


func get_size() -> Vector2i:
	return bottom_right - top_left + Vector2i.ONE

func get_area() -> int:
	var size = get_size()
	return size.x * size.y

func contains_point(point: Vector2i) -> bool:
	return point.x >= top_left.x and point.x <= bottom_right.x and \
		   point.y >= top_left.y and point.y <= bottom_right.y

func contains_rect(rect_top_left: Vector2i, rect_size: Vector2i) -> bool:
	var rect_bottom_right = rect_top_left + rect_size - Vector2i.ONE
	return rect_top_left.x >= top_left.x and rect_top_left.y >= top_left.y and \
		   rect_bottom_right.x <= bottom_right.x and rect_bottom_right.y <= bottom_right.y

func can_fit_size(size: Vector2i) -> bool:
	var zone_size = get_size()
	return size.x <= zone_size.x and size.y <= zone_size.y

func get_rect() -> Rect2i:
	return Rect2i(top_left, get_size())
