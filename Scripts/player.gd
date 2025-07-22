extends CharacterBody3D
@onready var left_hand: Node3D = $Head/Left_Hand
@onready var right_hand: Node3D = $Head/Right_Hand

var holding_item_left = null

var current_interactable = null
var speed
const WALK_SPEED = 1.5
const SPRINT_SPEED = 3.0
const CROUCH_SPEED = 0.2
const JUMP_VELOCITY = 40.5
const SENSITIVITY = 0.005

#bobbing
const BOB_FREQ = 8.2
const BOB_AMP = 0.11
var t_bob = 0.0
 
# fov
const BASE_FOV = 60.0
const FOV_CHANGE = 1.5

var crouch_scale = Vector3(1, 0.2, 1)
var stand_scale = Vector3(1, 1, 1)
var target_scale = stand_scale
var lerp_speed = 10.0  # Adjust this value to control the speed of the transition

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var ray_cast_3d: RayCast3D = $Head/Camera3D/RayCast3D

# Footstep variables
var can_play : bool = true
signal step

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-47),deg_to_rad(60))

func _input(event):
	if event.is_action_pressed("Interact"):
		interact()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		left_hand.play_grab()
		if left_hand.is_holding_item():
			left_hand.throw_item(camera)
		if current_interactable.is_in_group("Interactable"):
			print("interacting")
			interact()
		if current_interactable is Item:
			grab_leftHand()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		right_hand.play_grab()
		if right_hand.is_holding_item():
			right_hand.throw_item(camera)
		if current_interactable.is_in_group("Interactable"):
			interact()
		if current_interactable is Item:
			grab_rightHand()
			#'var camera = $Head/Camera3D
			#var from = camera.project_ray_origin(event.position)
			#var to = from + camera.project_ray_normal(event.position) * 5.0  # Reduced range for more precise placement
			
			#var space_state = get_world_3d().direct_space_state
			#var query = PhysicsRayQueryParameters3D.create(from, to)
			#query.collide_with_areas = true
			#query.collide_with_bodies = true
			#query.collision_mask = 0b1
			
			#var result = space_state.intersect_ray(query)
			
			#if result and result.has("position") and result.has("normal"):
			#	GraffitiSpawner.spawn_graffiti_at(result.position, result.normal)


func interact():
	print("trying to interact")
	if current_interactable.is_in_group("Interactable"):
		print("calling interact")
		current_interactable.interact()

func grab_rightHand():
	right_hand.pickup_item(current_interactable)
	
func grab_leftHand():
	#item.gravity_scale = 0
	#item.set_collision_layer_value(1,false)
	#item.set_collision_mask_value(1,false)
	#item.global_transform = L_item_point.global_transform
	#item.reparent(L_item_point)
	#holding_item_left = item

	left_hand.pickup_item(current_interactable)
	#current_interactable.global_position = left_hand.global_position

func _physics_process(delta):
	
	collision_shape_3d.scale = collision_shape_3d.scale.lerp(target_scale, lerp_speed * delta)


	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is Interactable:
			#print("collider is interactable")
			var new_interactable = collider.get_parent()
			if new_interactable != current_interactable:
				# Unregister previous interactable if different
				if current_interactable:
					current_interactable = null
					
					# Register new interactable
				current_interactable = new_interactable
				print(current_interactable)
		elif collider is Item:
			var new_interactable = collider
			if new_interactable != current_interactable:
				# Unregister previous interactable if different
				if current_interactable:
					current_interactable = null
					
					# Register new interactable
				current_interactable = new_interactable
				#print(current_interactable)
				#snyd
				#grab_leftHand()
				#current_interactable.interact()
	elif current_interactable:
		#current_interactable.interact()
		current_interactable = null
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("crouch"):
		target_scale = crouch_scale
	if Input.is_action_pressed("crouch"):
		speed = CROUCH_SPEED
	else:
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
			
		else:
			speed = WALK_SPEED
	if Input.is_action_just_released("crouch"):
		target_scale = stand_scale

	# Handle sprint
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

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide() 

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	var low_pos = BOB_AMP - 0.05
	# Check if we have reached a high point so we can restart can_play
	if pos.y > -low_pos:
		can_play = true
	
	#check if the head position has reached a low point then turn off can play to avoid
	#multiple spam of the emit signal
	if pos.y < -low_pos and can_play:
		can_play = false
		emit_signal("step")
	
	return pos
	
