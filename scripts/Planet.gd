@tool
extends RigidBody3D
class_name Planet

@export var planet_name : String = "Planet"
@export var planet_physics_data : CelestialBodyPhysicsData
@export var planet_build_data : CelestialBodyPaintData : set = set_planet_build_data

func set_planet_physics_data(val):
	planet_physics_data = val
	on_data_changed()
	var callable = Callable(self,"on_data_changed")
	if planet_physics_data != null and not planet_physics_data.changed.is_connected(callable):
		planet_physics_data.changed.connect(callable)

func set_planet_build_data(val):
	planet_build_data = val
	on_data_changed()
	var callable = Callable(self,"on_data_changed")
	if planet_build_data != null and not planet_build_data.changed.is_connected(callable):
		planet_build_data.changed.connect(callable)

func _ready():
	name = planet_name
	read_celestial_data()
	on_data_changed()
	
func read_celestial_data():
	pass

func on_data_changed():
	if planet_build_data != null:
		planet_build_data.min_height = 99999.9
		planet_build_data.max_height = 0.0
		print("Regenerate sphere...")
		for child in get_children():
			if child is CelestialBodyFaceMesh:
				var face = child as CelestialBodyFaceMesh
				face.regenerate_mesh(planet_build_data)

