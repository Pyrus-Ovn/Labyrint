extends CharacterBody3D
@onready var left_hand: Node3D = $Head/Left_Hand
@onready var right_hand: Node3D = $Head/Right_Hand

var holding_item_left = null

var current_interactable = null
var speed
const WALK_SPEED = 1.5
const SPRINT_SPEED = 3.0
const CROUCH_SPEED = 0.4
const JUMP_VELOCITY = 1.5
const SENSITIVITY = 0.005

#bobbing
const BOB_FREQ = 8.2
const BOB_AMP = 0.11
var t_bob = 0.0
 
# fov
const BASE_FOV = 60.0
const FOV_CHANGE = 1.5

var crouch_scale = Vector3( 0.5, 0.5,  0.5)
var stand_scale = Vector3(1, 1, 1)
var target_scale = stand_scale
var lerp_speed = 10.0  # Adjust this value to control the speed of the transition

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var ray_cast_3d: RayCast3D = $Head/Camera3D/RayCast3D
@onready var croucharea: RayCast3D = $Head/croucharea

#crouch hack
var can_uncrouch = true
var crouch_released = true

# Footstep variables
var can_play : bool = true
signal step

signal document_collected(DocumentResource)

# Flying variables
var is_flying = true
const FLY_SPEED = 2.0

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
		if current_interactable:
			if current_interactable.is_in_group("Interactable"):
				interact()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_flying = true
				
			else:
				is_flying = false
				
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		right_hand.play_grab()
		if right_hand.is_holding_item():
			if right_hand.is_holding_useable_item():
				right_hand.use_item()
			else:
				right_hand.throw_item(camera)
			
		if current_interactable:
			if current_interactable.is_in_group("Interactable"):
				interact()
		if current_interactable is Item:
			grab_rightHand()

func collect_document(document):
	emit_signal("document_collected",document)

func interact():
	
		current_interactable.interact()

func grab_rightHand():
	right_hand.pickup_item(current_interactable)
	
func grab_leftHand():
	left_hand.pickup_item(current_interactable)

func be_exploded(explosion):
	var throw_direction = -explosion.global_transform.basis.z.normalized()
	self.velocity = throw_direction * 10
	velocity.y = JUMP_VELOCITY*0.155
	velocity.z = JUMP_VELOCITY*0.2

func _physics_process(delta):
	
	collision_shape_3d.scale = collision_shape_3d.scale.lerp(target_scale, lerp_speed * delta)

	if croucharea.is_colliding():
		can_uncrouch = false
	else:
		can_uncrouch = true

	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is Interactable:
			var new_interactable = collider.get_parent()
			if new_interactable != current_interactable:
				if current_interactable:
					current_interactable.unhighlight()
					current_interactable = null
				current_interactable = new_interactable
				collider.highlight()
		elif collider is Item:
			var new_interactable = collider
			if new_interactable != current_interactable:
				if current_interactable:
					if current_interactable is Item:
						current_interactable.unhighlight()
						current_interactable = null
					else:
						current_interactable.interaction_area.unhighlight()
						current_interactable = null
				current_interactable = new_interactable
				new_interactable.highlight()
	elif current_interactable:
		if current_interactable is Item:
			current_interactable.unhighlight()
			current_interactable = null
		else:
			current_interactable.interaction_area.unhighlight()
			current_interactable = null

	# Handle flying movement
	if is_flying:
		# Get camera forward direction (ignoring pitch for horizontal movement)
		var camera_forward = -camera.global_transform.basis.z
		#camera_forward.y = 0  # Keep movement horizontal
		camera_forward = camera_forward.normalized()
		
		# Move in camera direction
		velocity = camera_forward * FLY_SPEED
	else:
		# Stand still when not flying
		velocity = Vector3.ZERO

	move_and_slide() 

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	var low_pos = BOB_AMP - 0.05
	if pos.y > -low_pos:
		can_play = true
	
	if pos.y < -low_pos and can_play:
		can_play = false
		emit_signal("step")
	
	return pos
