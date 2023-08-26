extends CharacterBody3D
## A brief description of the class's role and functionality.
##
## The description of the script, what it can do,
## and any further detail.
##
## @tutorial:            https://the/tutorial1/url.com
## @tutorial(Tutorial2): https://the/tutorial2/url.com

## Data object for the inventory
@export var inventory_data: InventoryData

## Speed of movement in 3D space
const SPEED = 5.0

## Jump velocity
const JUMP_VELOCITY = 4.5

## Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var health: int = 5:
	set(value):
		health = value

## Signal to tell the inventory UI to change its visibility and mouse mode.
signal toggle_inventory()

@onready var camera: Camera3D = $Camera3D
@onready var interact_ray: RayCast3D = $Camera3D/InteractRay

func _ready() -> void:
	PlayerManager.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Use for mouse events.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(remap(get_meta("InvertY", false), 1, 0, -1, 1) * -event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)


## Use for keyboard events.
func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

	if Input.is_action_just_pressed("interact"):
		interact()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()


func heal(heal_value: int) -> void:
	health += heal_value


## Get the position of where to drop an inventory item
func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction
