extends Node3D

@export var is_eliptical_orbit = true
@export var G : float = 100 
@export var sun_mass : float = 333000 
@export var earth_mass : float = 1 
@export var moon_mass : float = 0.01

@onready var earth = $Earth
@onready var sun = $Sun
@onready var moon = $Moon
@onready var earth_force_label : Label = $Camera3D/VBoxContainer/HBoxContainer/LabelEarthForce
@onready var sun_force_label  : Label = $Camera3D/VBoxContainer/HBoxContainer2/LabelSunForce
@onready var earth_velocity_label : Label = $Camera3D/VBoxContainer/HBoxContainer3/LabelEarthLinear
@onready var sun_velocity_label : Label = $Camera3D/VBoxContainer/HBoxContainer4/LabelSunLinear

var celestials : Array[RigidBody3D] = []

func _ready():
	earth.mass = earth_mass
	sun.mass = sun_mass
	moon.mass = moon_mass
	calculate_initial_velocity()

func calculate_initial_velocity():
	if celestials.size() == 0:
		for n in get_children():
			if n is RigidBody3D:
				celestials.append(n)
		
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


func _physics_process(delta):
	calculate_gravitaional_pull_sun_to_planet()

func calculate_gravitaional_pull_sun_to_planet():
	for a in celestials:
		for b in celestials:
			if a != b:
				var m1 = a.mass
				var m2 = b.mass
				var r = a.global_position.distance_to(b.global_position)
				
				var force_direction = (b.global_position - a.global_position).normalized()
				var force = force_direction * (G * (m1 * m2) / (r * r))
				
				if a.name == 'Earth':
					#force += earth_initial_velocity
					earth_force_label.text = str(force)
					earth_velocity_label.text = str(a.linear_velocity)
				if a.name == 'Sun':
					sun_force_label.text = str(force)
					sun_velocity_label.text = str(a.linear_velocity)
					
				a.apply_central_force(force)

