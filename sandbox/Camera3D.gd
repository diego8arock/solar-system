extends Camera3D

@onready var sun : RigidBody3D = get_parent().get_node("Sun")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector3(sun.global_position.x, global_position.y, sun.global_position.z) 
