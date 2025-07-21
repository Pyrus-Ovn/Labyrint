extends Node3D
const green = "ff0000"
const red = "ff0000"
@onready var lever_handle: MeshInstance3D = $lever_handle
@onready var lever_base: MeshInstance3D = $lever_base


@export var toggled : bool = false
@onready var interaction_area: Interactable = $InteractionArea

var open_position = Vector3(26,0,0)
var closed_position = Vector3(-26,0,0)

var animation_progress := 0.0
var animation_speed := 1.5

signal toggle(state:bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func ease_out_quad(progress: float, target: float) -> float:
	if target == 1.0:
		return -progress * (progress - 2)
	else:
		return progress * progress

func _process(delta: float) -> void:
	if animation_progress < 1.0:
		animation_progress += delta * animation_speed
		animation_progress = min(animation_progress, 1.0)  # Clamp to 1.0
		
		var target_progress = 1.0 if toggled else 0.0
		var lerp_amount = ease_out_quad(animation_progress, target_progress)
		
		# Interpolate positions
		if toggled:
			lever_handle.rotation = closed_position.lerp(open_position, lerp_amount)
		else:
			lever_handle.rotation = open_position.lerp(closed_position, lerp_amount)

func interact():
	toggled = !toggled
	toggle.emit(toggled)
	
	## Get the material of the mesh
	#var material = self.mesh_instance_3d.get_surface_override_material(0)
	#
	## If there's no material, create a new StandardMaterial3D
	#if material == null:
		#material = StandardMaterial3D.new()
		#self.mesh_instance_3d.set_surface_override_material(0, material)
	#
	## Set the color based on the toggle state
	#if toggled:
		#material.albedo_color = Color.GREEN
	#else:
		#material.albedo_color = Color.RED
