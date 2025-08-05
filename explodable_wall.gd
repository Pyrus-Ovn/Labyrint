extends Node3D


@onready var boulder: MeshInstance3D = $Boulder
@onready var boulder_destroy: MeshInstance3D = $BoulderDestroy
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func be_exploded(explosion):
	explode()

func explode():
	#collision_shape_3d.disabled = true
	collision_shape_3d.scale = Vector3(0.1,0.1,0.1)
	print(collision_shape_3d.disabled)
	boulder_destroy.visible = true
	boulder.visible = false
