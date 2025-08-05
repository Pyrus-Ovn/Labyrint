extends Node3D
const DYNAMIT = preload("res://Scenes/Items/dynamit.tscn")
# Called when the node enters the scene tree for the first time.
@onready var dynamite_spawnpoint: Marker3D = $Marker3D
@onready var well_interaction: CollisionShape3D = $InteractionArea/CollisionShape3D
@onready var interaction_area: Interactable = $InteractionArea
@onready var up: AudioStreamPlayer2D = $up
@onready var pickup_sfx: AudioStreamPlayer3D = $PickupSFX

var coin_putin = false
func _ready() -> void:
	well_interaction.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("coin"):
		pickup_sfx.play()
		coin_putin = true
		well_interaction.call_deferred("set_disabled", false)
		body.queue_free()

func spawn_dynamite():
	up.play()
	# Create a new dynamite instance
	var dynamite_instance = DYNAMIT.instantiate()
	
	# Add it to the scene tree as a child of this node
	add_child(dynamite_instance)
	
	# Set the dynamite's position to the spawn point
	dynamite_instance.global_transform = dynamite_spawnpoint.global_transform
	
	# Generate random directions for x and z (between -1 and 1)
	var random_x = randf_range(-3.0, 3.0)
	var random_z = randf_range(-3.0, 3.0)
	
	# Apply an upward impulse with random x and z components
	var impulse_strength = 1.0  # Adjust this value to control how high/far the dynamite goes
	var impulse = Vector3(random_x, 1.0, random_z).normalized() * impulse_strength
	
	dynamite_instance.item_body 
	dynamite_instance.item_body .linear_velocity = impulse * impulse_strength
	dynamite_instance.item_body .angular_velocity = Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5))
	dynamite_instance.item_body .apply_central_impulse(Vector3.UP * 3)


func interact():
	if coin_putin:
		spawn_dynamite()
