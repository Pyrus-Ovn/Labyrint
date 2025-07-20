# graffiti_spawner.gd
extends Node

const CROSS = preload("res://Assets/cross.png")

@export var graffiti_textures: Array[Texture] = [CROSS]
@export var max_graffiti_count := 20
@export var decal_size := Vector3(1, 1, 0.1)
@export var decal_offset := 0.01  # Increased from 0.05 to ensure visibility

var current_graffiti_index := 0
var spawned_decals := []

func spawn_graffiti_at(position: Vector3, normal: Vector3):
	
	
	var decal = Decal.new()
	decal.texture_albedo = graffiti_textures[current_graffiti_index]
	decal.size = decal_size
	decal.cull_mask = 0b1
	
	var decal_node = Node3D.new()
	decal_node.add_child(decal)
	add_child(decal_node)
	
	# Improved positioning with better offset calculation
	var offset_position = position + (normal * decal_offset)
	decal_node.global_transform.origin = offset_position
	decal_node.look_at(position + normal, Vector3.UP)
	
	# Adjust decal distance based on view angle
	var camera = $Head/Camera3D

	if camera:
		var view_vector = (offset_position - camera.global_transform.origin).normalized()
		var view_angle = view_vector.dot(normal)
		var dynamic_offset = decal_offset * (1.0 + (1.0 - abs(view_angle)))
		offset_position = position + (normal * dynamic_offset)
		decal_node.global_transform.origin = offset_position
	
	spawned_decals.append(decal_node)
	_manage_graffiti_count()

func _manage_graffiti_count():
	if spawned_decals.size() > max_graffiti_count:
		var oldest = spawned_decals.pop_front()
		oldest.queue_free()

func cycle_graffiti_texture():
	current_graffiti_index = (current_graffiti_index + 1) % graffiti_textures.size()
