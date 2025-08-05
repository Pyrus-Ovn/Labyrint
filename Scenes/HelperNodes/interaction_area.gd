# Extended Interactable example with highlighting
extends Node3D
class_name Interactable

@export var mesh: MeshInstance3D
const outline_material = preload("res://Assets/simple_outline/perfect_OUTLINE_SHADER.tres")

func interact():
	pass  # Implement in child classes

func highlight():
	# Add visual feedback
	mesh.material_overlay = outline_material

func unhighlight():
	# Remove visual feedback
	mesh.material_overlay = null
