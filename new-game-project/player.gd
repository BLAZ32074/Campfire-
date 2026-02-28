extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sensX = 0.01
const sensY = 0.01
const maxX = 90
const minX = -90
var state = 0
var interact = 0
var flashlightOn = 0

@onready var head = $camPos
@onready var camera = $camPos/Camera3D
@onready var raycast = $camPos/Camera3D/RayCast3D
@onready var flashlight = $camPos/Camera3D/SpotLight3D
@onready var flashlight2 = $camPos/Camera3D/SpotLight3D2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensY)
		camera.rotate_x(-event.relative.y * sensX)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(minX), deg_to_rad(maxX))

func _process(delta: float) -> void:
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		print(hit.name)
		interact = 1
	else:
		interact = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Interact"):
		if flashlightOn == 0:
			flashlight.light_energy = 20
			flashlight.light_energy = 5
			flashlightOn = 1
		elif flashlightOn == 1:
			flashlight.light_energy = 0
			flashlight.light_energy = 0
			flashlightOn = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
