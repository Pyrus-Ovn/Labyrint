extends Node3D
@onready var item_body: Item = $Item_body
@onready var dynamit: MeshInstance3D = $Item_body/dynamit
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Item_body/AudioStreamPlayer3D

#@onready var explosion_spawner_2: Node3D = $ExplosionSpawner2
@onready var explosion_spawner: Node3D = $Item_body/ExplosionSpawner

#func _on_timer_timeout():
	#explosion_spawner_2.explode() #

#func _on_item_body_body_entered(body: Node) -> void:
	#print("hu ha")
#
	#await get_tree().create_timer(3.0).timeout
	#explosion_spawner_2.explode() # Replace with function body.


func _on_item_body_used() -> void:
	audio_stream_player_3d.play()
	await get_tree().create_timer(3.0).timeout
	
	explosion_spawner.explode()
	audio_stream_player_3d.stop()
	dynamit.visible = false
	await get_tree().create_timer(0.8).timeout
	dynamit.queue_free()
	item_body.queue_free() # Replace with function body.
