extends Node3D
@onready var animation_player: AnimationPlayer = $left_hand_anim2/AnimationPlayer

func play_grab():

	animation_player.play("GRAB_hand")
	animation_player.queue("IDLE_hand")
