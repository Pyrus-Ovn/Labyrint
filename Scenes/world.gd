extends Node3D


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
