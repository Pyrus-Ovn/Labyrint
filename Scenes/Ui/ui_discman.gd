extends Control
@onready var discer: Control = $Discer
#@onready var song_label: Label = $Label
@onready var song_label: Label = $Discer/Discman/Label
@onready var hide_button: TextureButton = $Hidebuttoncontroller/hide_Button
@onready var click: AudioStreamPlayer2D = $Discer/Discman/click
@onready var up: AudioStreamPlayer2D = $Discer/Discman/up
@onready var down: AudioStreamPlayer2D = $Discer/Discman/down

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the autoload music player
	Globaldiscman.connect("song_changed", _on_song_changed)
# Update immediately if song is playing
	if Globaldiscman.current_song_index != -1:
		_on_song_changed(Globaldiscman.get_current_song_name(), Globaldiscman.current_song_index)

func _on_song_changed(song_name: String, _song_index: int):
	song_label.text = song_name
	if !discer.visible:
		_on_hide_button_toggled(true)
		hide_button.button_pressed = true



func _on_hide_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		up.play()
	else:
		down.play()
	discer.visible = toggled_on


func _on_play_button_pressed() -> void:
	click.play()
	Globaldiscman.play() # Replace with function body.


func _on_forward_button_pressed() -> void:
	click.play()
	Globaldiscman.play_next()


func _on_back_button_pressed() -> void:
	click.play()
	Globaldiscman.play_previous()
