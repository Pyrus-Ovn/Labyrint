extends Node3D
@onready var animation_player: AnimationPlayer = $right_hand_anim/AnimationPlayer

func play_grab():

	animation_player.play("GRAB_hand")
	animation_player.queue("IDLE_hand")
