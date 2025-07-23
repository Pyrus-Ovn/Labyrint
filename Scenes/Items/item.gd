class_name Item extends RigidBody3D

@export var useable = false

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
	pass

func unhighlight():
	# Remove visual feedback
	pass
