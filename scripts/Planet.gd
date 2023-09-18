@tool
extends Node3D

@export var planet_data : PlanetData : set = set_planet_data

func set_planet_data(val):
	planet_data = val
	on_data_changed()
	var callable = Callable(self,"on_data_changed")
	if planet_data != null and not planet_data.changed.is_connected(callable):
		planet_data.changed.connect(callable)

func _ready():
	on_data_changed()

func on_data_changed():
	if planet_data != null:
		print("Regenerate sphere...")
		for child in get_children():
			var face = child as PlanetFaceMesh
			face.regenerate_mesh(planet_data)

