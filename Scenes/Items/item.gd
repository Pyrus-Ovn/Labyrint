class_name Item extends RigidBody3D

@export var useable = false

@export var mesh: MeshInstance3D
const outline_material = preload("res://Assets/simple_outline/perfect_OUTLINE_SHADER.tres")
signal used()
func throw():
	
	pass  # Implement in child classes


func has_use():
	return useable

func use():
	emit_signal("used")
	useable = false

func interact():
	#pickup
	pass  

func highlight():
	# Add visual feedback
	mesh.material_overlay = outline_material

func unhighlight():
	# Remove visual feedback
	mesh.material_overlay = null
