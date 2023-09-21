@tool
extends Resource
class_name CelestialBodyData

enum CELESTIAL_BODY_TYPE
{
	SUN, 
	PLANET, 
	MOON , 
	ASTEROID
}

@export var type : CELESTIAL_BODY_TYPE = 0
@export var mass : float = 1.0
@export var initial_linear_velocity : float = 1.0
