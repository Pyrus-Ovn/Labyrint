extends Node3D
const green = "ff0000"
const red = "ff0000"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
"albedo_color"

@export var toggled : bool = false
@onready var interaction_area: Interactable = $InteractionArea

signal toggle(state:bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	toggled = !toggled
	toggle.emit(toggled)
	
	# Get the material of the mesh
	var material = self.mesh_instance_3d.get_surface_override_material(0)
	
	# If there's no material, create a new StandardMaterial3D
	if material == null:
		material = StandardMaterial3D.new()
		self.mesh_instance_3d.set_surface_override_material(0, material)
	
	# Set the color based on the toggle state
	if toggled:
		material.albedo_color = Color.GREEN
	else:
		material.albedo_color = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
