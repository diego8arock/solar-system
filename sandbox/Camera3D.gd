extends Camera3D

# Camera movement speeds
var move_speed: float = 30.0
var mouse_sensitivity: float = 0.1

# Variables to hold mouse movement
var last_mouse_pos: Vector2 = Vector2()
var pitch: float = 0.0
var yaw: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# Handle movement
	var direction = Vector3()

	if Input.is_action_pressed("move_forward"):
		direction += -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction -= -transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_up"):
		direction += transform.basis.y
	if Input.is_action_pressed("move_down"):
		direction -= transform.basis.y

	direction = direction.normalized()

	# Apply the movement
	self.global_translate(direction * move_speed * delta)
	
func _input(event):
	# Rotate the camera using the mouse
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		pitch = clamp(pitch, -70, 70)  # Prevents over-rotation

		# Apply the rotations
		self.rotation_degrees.x = pitch
		self.rotation_degrees.y = yaw
