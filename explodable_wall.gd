extends Node3D

@onready var rockwall: MeshInstance3D = $rockwall
@onready var rockwall_destroy: MeshInstance3D = $rockwall_destroy
@onready var collision_shape_3d: CollisionShape3D = $rockwall/StaticBody3D/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func be_exploded(explosion):
	explode()

func explode():
	rockwall_destroy.visible=true
	rockwall.visible = false
	collision_shape_3d.disabled = true
