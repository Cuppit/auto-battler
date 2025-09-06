class_name ZoneManager
extends Node

var zones: Array[Zone] = []

func add_zone(zone_name: String, top_left: Vector2i, bottom_right: Vector2i):
	var zone = Zone.new(zone_name, top_left, bottom_right)
	zones.append(zone)

func get_zone(zone_name: String) -> Zone:
	for zone in zones:
		if zone.name == zone_name:
			return zone
	return null

func find_zones_that_can_fit(size: Vector2i) -> Array[Zone]:
	var fitting_zones: Array[Zone] = []
	for zone in zones:
		if zone.can_fit_size(size):
			fitting_zones.append(zone)
	return fitting_zones

func find_best_fit_zone(size: Vector2i) -> Zone:
	var best_zone: Zone = null
	var smallest_area = INF
	
	for zone in zones:
		if zone.can_fit_size(size):
			var zone_area = zone.get_area()
			if zone_area < smallest_area:
				smallest_area = zone_area
				best_zone = zone
	
	return best_zone

func try_place_rect_in_zone(zone_name: String, rect_size: Vector2i) -> Vector2i:
	var zone = get_zone(zone_name)
	if zone and zone.can_fit_size(rect_size):
		# Return top-left position where it would fit
		return zone.top_left
	return Vector2i(-1, -1)  # Invalid position
