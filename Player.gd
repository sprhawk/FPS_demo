extends CharacterBody3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY: float = -30
const MAX_SPEED: float = 8
const MOUSE_SENSITITY: float = 0.002

var velocity: Vector3 = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.velocity = Vector3.ZERO

func get_direction():
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction += -self.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction +=  self.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		direction += -self.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		direction +=  self.global_transform.basis.x
	return direction.normalized()
		
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_evt = event as InputEventMouseMotion
		rotate_y(-mouse_evt.relative.x * MOUSE_SENSITITY)
		$Head.rotate_x(-mouse_evt.relative.y * MOUSE_SENSITITY)
		$Head.rotation.x = clamp($Head.rotation.x, -1.2, 1.2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _physics_process(delta):
	var direction = get_direction()
	velocity.y = GRAVITY * delta
	var desired_velocity = direction * MAX_SPEED
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	var collision = move_and_collide(velocity)
