extends Node3D

@export var is_eliptical_orbit = false
@export var G : float = 1000 
@export var sun_mass : float = 333000 
@export var mercury_mass : float = 100
@export var venus_mass : float = 130
@export var earth_mass : float = 150
@export var moon_mass : float = 0.01
@export var mass_multiplier : float = 1.0

@onready var earth = $Earth
@onready var sun = $Sun
@onready var moon = $Moon
@onready var mercury = $Mercury
@onready var venus = $Venus

@onready var asteroid_scene = preload("res://sandbox/asteroid.tscn")

var celestials : Array[RigidBody3D] = []
var paths_and_curves = {}

func _ready():
	randomize()
	spawn_asteroids()
	initialize_celestials()
	calculate_initial_velocity()
	print_info()
	
func initialize_celestials():
	if celestials.size() == 0:
		for n in get_children():
			if n is RigidBody3D:
				celestials.append(n)
				if  not n.is_in_group("asteroids"):
					var path = Path3D.new()
					var curve = Curve3D.new()
					path.curve = curve
					add_child(path)
					paths_and_curves[n] = curve
	
	earth.mass = earth_mass * mass_multiplier
	sun.mass = sun_mass  * mass_multiplier
	moon.mass = moon_mass * mass_multiplier
	mercury.mass = mercury_mass * mass_multiplier
	venus.mass = venus_mass * mass_multiplier

func calculate_initial_velocity():
	if celestials.size() == 0:
		for n in get_children():
			if n is RigidBody3D:
				celestials.append(n)
				if  not n.is_in_group("asteroids"):
					var path = Path3D.new()
					var curve = Curve3D.new()
					path.curve = curve
					add_child(path)
					paths_and_curves[n] = curve
		
	for a in celestials:
		for b in celestials:
			if a != b:
				var m2 = b.mass
				var r = a.global_position.distance_to(b.global_position)
				
				a.look_at(b.global_position)
				
				if is_eliptical_orbit:
					a.linear_velocity += (a.global_transform.basis.x * sqrt((G * m2) * ((2 / r) - (1 / (r * 1.5)))))
				else:
					a.linear_velocity += (a.global_transform.basis.x * sqrt((G * m2) / r))
					


func _physics_process(delta):
	for n in paths_and_curves.keys():
		var curve = paths_and_curves[n]
		curve.add_point(n.global_position)
	calculate_gravitaional_pull_sun_to_planet()

func calculate_gravitaional_pull_sun_to_planet():
	var celestial_count = celestials.size()
	for i in range(celestial_count):
		for j in range(i + 1, celestial_count):
			apply_gravitational_force(celestials[i], celestials[j])
				
func apply_gravitational_force(a, b):
	var m1 = a.mass
	var m2 = b.mass
	var r = a.global_position.distance_to(b.global_position)

	var force_direction = (b.global_position - a.global_position).normalized()
	var force = force_direction * (G * (m1 * m2) / (r * r))

	a.apply_central_force(force)
	b.apply_central_force(-force)
				
func spawn_asteroids():
	var density = 50
	
	var height = 100
	var inner_radius = 5250.0
	var outer_radius = 8250.0
	var random_radius
	var ranodm_radian
	
	var local_position : Vector3
	
	for i in range(density):
		
		var x = null
		var y = null
		var z = null
		
		while y == null and x == null:
			random_radius = randf_range(inner_radius, outer_radius)
			ranodm_radian = randf_range(0, (2 * PI))
			
			y = randf_range(-(height /2), (height / 2))
			x = random_radius * cos(ranodm_radian)
			z = random_radius * sin(ranodm_radian)
		
		local_position = Vector3(x, y, z)
		
		var asteroid : RigidBody3D = asteroid_scene.instantiate()
		add_child(asteroid)
		asteroid.global_position = local_position
		asteroid.mass = 0.001  * mass_multiplier
		asteroid.add_to_group("asteroids")
		
func print_info():
	print("G: %f" % G)
	print("earth")
	print("linear velocity: %s" % earth.linear_velocity)
	print("mass: %f" % earth.mass)
	print("sun")
	print("linear velocity: %s" % sun.linear_velocity)
	print("mass: %f" % sun.mass)
	print("moon")
	print("linear velocity: %s" % moon.linear_velocity)
	print("mass: %f" % moon.mass)
	print("\n")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
