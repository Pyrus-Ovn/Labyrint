extends CharacterBody3D


var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 40.5
const SENSITIVITY = 0.005

#bobbing
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0
 
# fov
const BASE_FOV = 60.0
const FOV_CHANGE = 1.5

var crouch_scale = Vector3(1, 0.5, 1)
var stand_scale = Vector3(1, 1, 1)
var target_scale = stand_scale
var lerp_speed = 10.0  # Adjust this value to control the speed of the transition


@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = $Head/Camera3D
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 5.0  # Reduced range for more precise placement
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.collision_mask = 0b1
		
		var result = space_state.intersect_ray(query)
		
		if result and result.has("position") and result.has("normal"):
			GraffitiSpawner.spawn_graffiti_at(result.position, result.normal)


func _physics_process(delta):
	
	collision_shape_3d.scale = collision_shape_3d.scale.lerp(target_scale, lerp_speed * delta)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("crouch"):
		target_scale = crouch_scale
	if Input.is_action_just_released("crouch"):
		target_scale = stand_scale

	# Handle sprint
	if Input.is_action_just_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x,direction.x*speed, delta * 7.0 )
			velocity.z = lerp(velocity.z,direction.z*speed, delta * 7.0 )
	else: 
		velocity.x = lerp(velocity.x,direction.x*speed, delta * 3.0 )
		velocity.z = lerp(velocity.z,direction.z*speed, delta * 3.0 )


	move_and_slide() 
