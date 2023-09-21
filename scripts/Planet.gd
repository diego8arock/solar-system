@tool
extends RigidBody3D
class_name Planet

@export var celestial_body_data : CelestialBodyData
@export var planet_data : PlanetData : set = set_planet_data


func set_planet_data(val):
	planet_data = val
	on_data_changed()
	var callable = Callable(self,"on_data_changed")
	if planet_data != null and not planet_data.changed.is_connected(callable):
		planet_data.changed.connect(callable)

func _ready():
	linear_velocity = Vector3(0, 0, celestial_body_data.initial_linear_velocity)
	print(linear_velocity)
	on_data_changed()

func on_data_changed():
	if planet_data != null:
		planet_data.min_height = 99999.9
		planet_data.max_height = 0.0
		print("Regenerate sphere...")
		for child in get_children():
			if child is PlanetFaceMesh:
				var face = child as PlanetFaceMesh
				face.regenerate_mesh(planet_data)

