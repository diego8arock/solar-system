@tool
extends Resource
class_name PlanetData

@export var radius = 1 : set = set_radius
@export var resolution = 10 : set = set_resolution

func set_radius(val):
	radius = val
	emit_changed()
	
func set_resolution(val):
	resolution = val
	emit_changed()
