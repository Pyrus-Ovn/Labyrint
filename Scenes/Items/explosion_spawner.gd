extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	collision_shape_3d.disabled = true

# Called when the node enters the scene tree for the first time.
func explode() -> void:
	print("trying to explode")
	audio_stream_player_3d.play()
	animation_player.play("Explode") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("be_exploded"):
		body.be_exploded(self)
