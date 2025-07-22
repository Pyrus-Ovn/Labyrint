extends Node3D
@onready var hinges: Node3D = $Hinges
@onready var open_sfx: AudioStreamPlayer3D = $OpenSFX
@onready var close_sfx: AudioStreamPlayer3D = $CloseSFX

@export var reverse_door : bool = false
var open : bool = reverse_door

var open_position = Vector3(0,90,0)
var closed_position = Vector3(0,0,0)

var animation_progress := 0.0
var animation_speed := 0.5

signal toggle(state:bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open = reverse_door

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


func toggle_door(state: bool):
	#held og lykke med at fatte det her
	open = (state != reverse_door)
	
	print(open)
	
	animation_progress = 1.0 - animation_progress
	if open:
		open_sfx.play()
	else:
		close_sfx.play()


func _on_lever_toggle(state: bool) -> void:
	toggle_door(state)

func _on_lever_2_toggle(state: bool) -> void:
	toggle_door(state)



func _on_lever_4_toggle(state: bool) -> void:
	toggle_door(state)



func _on_lever_5_toggle(state: bool) -> void:
	toggle_door(state)



func _on_lever_6_toggle(state: bool) -> void:
	toggle_door(state)



func _on_lever_7_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_8_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_9_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_11_toggle(state: bool) -> void:
	toggle_door(state)





func _on_lever_19_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_23_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_12_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_16_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_24_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_17_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_21_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_29_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_18_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_22_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_26_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_30_toggle(state: bool) -> void:
	toggle_door(state)


func _on_lever_3_toggle(state: bool) -> void:
	toggle_door(state)


func _on_toggle(state: bool) -> void:
		toggle_door(state)
		
