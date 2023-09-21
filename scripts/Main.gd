@tool
extends Node3D

@export var G : float = 100

var sun : Sun
var planets : Array[Planet]

func _ready():
	print(G)
	Engine.time_scale = 5.0 
	for child in get_children():
			if child is Sun:
				sun = child
				print(sun.celestial_body_data.mass)
			if child is Planet:
				print(child.celestial_body_data.mass)
				planets.append(child)


func _physics_process(delta):
	for p in planets:
		calculate_gravitaional_pull_sun_to_planet(p, delta)
	
func calculate_gravitaional_pull_sun_to_planet(planet : Planet, delta : float):
	var distance_vector = planet.global_position - sun.global_position
	var distance = distance_vector.length()
	
	if distance < 1.0:
		return
	
	var F_magnitude = G * sun.celestial_body_data.mass * planet.celestial_body_data.mass / distance**2
	var F_vector = distance_vector.normalized() * F_magnitude
	#print(-F_vector * delta)
	#planet.apply_central_force(-F_vector * delta)
