extends Node3D
@onready var hinges: Node3D = $Hinges
@onready var open_sfx: AudioStreamPlayer3D = $OpenSFX
@onready var close_sfx: AudioStreamPlayer3D = $CloseSFX

@export var open : bool = false

var open_position = Vector3(0,90,0)
var closed_position = Vector3(0,0,0)

var animation_progress := 0.0
var animation_speed := 0.5

signal toggle(state:bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func ease_out_quad(progress: float, target: float) -> float:
	if target == 1.0:
		return -progress * (progress - 2)
	else:
		return progress * progress

func _process(delta: float) -> void:
	if animation_progress < 1.0:
		animation_progress += delta * animation_speed
		animation_progress = min(animation_progress, 1.0)  # Clamp to 1.0
		
		var target_progress = 1.0 if open else 0.0
		var lerp_amount = ease_out_quad(animation_progress, target_progress)
		
		# Interpolate positions
		if open:
			hinges.rotation_degrees = closed_position.lerp(open_position, lerp_amount)
		else:
			hinges.rotation_degrees = open_position.lerp(closed_position, lerp_amount)


func _on_lever_toggle(state: bool) -> void:
	open = state
	animation_progress = 1.0 - animation_progress
	if open:
		open_sfx.play()
	else:
		close_sfx.play()
