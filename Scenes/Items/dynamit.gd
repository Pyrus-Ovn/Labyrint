extends Node3D


#@onready var explosion_spawner_2: Node3D = $ExplosionSpawner2
@onready var explosion_spawner_2: Node3D = $Item_body/ExplosionSpawner2

#func _on_timer_timeout():
	#explosion_spawner_2.explode() #

#func _on_item_body_body_entered(body: Node) -> void:
	#print("hu ha")
#
	#await get_tree().create_timer(3.0).timeout
	#explosion_spawner_2.explode() # Replace with function body.


func _on_item_body_used() -> void:
	await get_tree().create_timer(3.0).timeout
	explosion_spawner_2.explode() # Replace with function body.
