extends Node3D
@onready var scaler: Node3D = $Scaler
@onready var papir_sfx: AudioStreamPlayer3D = $papirSFX
@export var document: DocumentResource

@onready var pickup_sfx: AudioStreamPlayer3D = $PickupSFX



func _on_area_3d_body_entered(body: Node3D) -> void:
	#add data to discman
	#play crazy effects
	if body.is_in_group("Player"):
		if document:
			body.collect_document(document)
		papir_sfx.stop()
		pickup_sfx.play()
		scaler.visible = false
		await  pickup_sfx.finished
		
		queue_free()
	
