extends Control

@onready var unit_name = $ColorRect/VBoxContainer/UnitName
@onready var icon = $ColorRect/VBoxContainer/TabContainer/Stats/Icon
@onready var icon_desc = $ColorRect/VBoxContainer/TabContainer/Description/Icon

func display_unit_details(unit):
	unit_name.text = unit.unit_name
	if(unit.is_in_group("Team1")):
		icon.texture = unit.red_team_skin
		icon_desc.texture = unit.red_team_skin
	else:
		icon.texture = unit.blue_team_skin
		icon_desc.texture = unit.blue_team_skin
