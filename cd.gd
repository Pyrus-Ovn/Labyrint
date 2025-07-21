extends Node3D





func _on_area_3d_body_entered(_player: Node3D) -> void:
	#add data to discman
	#play crazy effects
	queue_free()
	
