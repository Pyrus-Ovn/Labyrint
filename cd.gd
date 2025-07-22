extends Node3D
@onready var scaler: Node3D = $Scaler

@onready var cd_sfx: AudioStreamPlayer3D = $cdSFX
const NUMBER_OF_CD = 2
@export_range(1, NUMBER_OF_CD) var disc_number : int

@onready var pickup_sfx: AudioStreamPlayer3D = $PickupSFX



func _on_area_3d_body_entered(body: Node3D) -> void:
	#add data to discman
	#play crazy effects
	if body.is_in_group("Player"):
		Globaldiscman.pickup_disc(disc_number)
		cd_sfx.stop()
		pickup_sfx.play()
		scaler.visible = false
		await  pickup_sfx.finished
		
		queue_free()
	
