extends Node3D



func _on_start_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/World.tscn")
 # Replace with function body.


func _on_exit_pressed() -> void:
			get_tree().quit()
 # Replace with function body.
