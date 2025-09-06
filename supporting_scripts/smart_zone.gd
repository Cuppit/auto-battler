class_name SmartZone
extends Zone

var occupied_rects: Array[Rect2i] = []

func is_area_free(rect: Rect2i) -> bool:
	# Check if the rect is within zone bounds
	if not contains_rect(rect.position, rect.size):
		return false
	
	# Check if it overlaps with any occupied rectangles
	for occupied in occupied_rects:
		if rect.intersects(occupied):
			return false
	
	return true

func place_rect(rect: Rect2i) -> bool:
	if is_area_free(rect):
		occupied_rects.append(rect)
		return true
	return false

func remove_rect(rect: Rect2i) -> bool:
	var index = occupied_rects.find(rect)
	if index >= 0:
		occupied_rects.remove_at(index)
		return true
	return false

func find_free_position(size: Vector2i) -> Vector2i:
	# Simple left-to-right, top-to-bottom placement
	for y in range(top_left.y, bottom_right.y - size.y + 2):
		for x in range(top_left.x, bottom_right.x - size.x + 2):
			var test_rect = Rect2i(Vector2i(x, y), size)
			if is_area_free(test_rect):
				return Vector2i(x, y)
	
	return Vector2i(-1, -1)  # No free position found
