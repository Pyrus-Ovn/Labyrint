extends Node3D
@onready var animation_player: AnimationPlayer = $left_hand_anim2/AnimationPlayer
@onready var item_point: Marker3D = $left_hand_anim2/bone/geo_Vhånd_åben/Item_point

const THROW_FORCE = 5
const UPWARD_FORCE = 1

var holding_item = null
func play_grab():

	animation_player.play("GRAB_hand")
	animation_player.queue("IDLE_hand")

func pickup_item(item):
	
	item.freeze = true 
	item.set_collision_layer_value(1, false)
	item.set_collision_mask_value(1, false)
	item.global_position = item_point.global_position
	item.global_rotation = item_point.global_rotation
	item.reparent(item_point)
	holding_item = item

func is_holding_item():
	if holding_item:
		return true
	return false
	
func is_holding_useable_item():
	if holding_item:
		return holding_item.has_use()
	return false

func use_item():
	if not holding_item:
		return
	holding_item.use()

func throw_item(camera):
	if not holding_item:
		return
		
	var item = holding_item
	holding_item = null
	
	item.reparent(get_tree().current_scene)  # Reparent to scene root
	item.freeze = false
	item.set_collision_layer_value(1, true)
	item.set_collision_mask_value(1, true)
	var throw_direction = -camera.global_transform.basis.z.normalized()
	item.linear_velocity = throw_direction * THROW_FORCE
	item.angular_velocity = Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5))
	item.apply_central_impulse(Vector3.UP * UPWARD_FORCE)
