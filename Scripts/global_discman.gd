extends Node
class_name Discman

# Static playlist - songs are only added once
var songs: Array = []
var current_song_index: int = -1
var audio_player: AudioStreamPlayer
var _song_paths: Array = []  # Track added paths to ensure uniqueness

# Signal emitted when a new song starts playing
signal song_changed(song_name, song_index)

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.connect("finished", _on_song_finished)
	add_song("res://Audio/Songs/bossmusic.wav")
	add_song("res://Audio/Songs/Shop Music (final).wav")
	
func  _on_song_finished():
	play_next()

# Add a song to the playlist if it's not already there
func add_song(song_path: String) -> bool:
	# Check if song already exists
	if _song_paths.has(song_path):
		return false
		
	var song = load(song_path)
	if song is AudioStream:
		songs.append(song)
		_song_paths.append(song_path)
		
		# If this is the first song added, set as current
		if current_song_index == -1:
			current_song_index = 0
			audio_player.stream = song
			
		return true
	return false

# Play the current song (or first song if none is selected)
func play():
	if songs.size()==0:
		push_warning("No songs in playlist")
		return
		
	# If no song is selected but we have songs, select first
	if current_song_index == -1:
		current_song_index = 0
		audio_player.stream = songs[current_song_index]
		
	if not audio_player.playing:
		audio_player.play()
		emit_signal("song_changed", get_current_song_name(), current_song_index)
	elif audio_player.stream_paused:
		resume()
		emit_signal("song_changed", get_current_song_name(), current_song_index)
	else:
		pause()
		emit_signal("song_changed", "Paused", current_song_index)

# Pause playback (keeps position)
func pause():
	audio_player.stream_paused = true

# Resume playback from paused position
func resume():
	audio_player.stream_paused = false

# Stop playback and reset position
func stop():
	audio_player.stop()

# Play next song in playlist (loops to start if at end)
func play_next():
	if songs.is_empty():
		push_warning("No songs in playlist")
		return
		
	current_song_index = (current_song_index + 1) % songs.size()
	audio_player.stream = songs[current_song_index]
	audio_player.play()
	emit_signal("song_changed", get_current_song_name(), current_song_index)

# Play previous song in playlist (loops to end if at start)
func play_previous():
	if songs.is_empty():
		push_warning("No songs in playlist")
		return
		
	current_song_index -= 1
	if current_song_index < 0:
		current_song_index = songs.size() - 1
	audio_player.stream = songs[current_song_index]
	audio_player.play()
	emit_signal("song_changed", get_current_song_name(), current_song_index)

# Get name of current song (without extension)
func get_current_song_name() -> String:
	if songs.is_empty() or current_song_index == -1:
		return "No song playing"
	
	var path = _song_paths[current_song_index]
	return path.get_file().get_basename()

# Get the current playlist (as paths)
func get_playlist() -> Array:
	return _song_paths.duplicate()

# Check if a song exists in the playlist
func has_song(song_path: String) -> bool:
	return _song_paths.has(song_path)

# Get current playback position in seconds
func get_playback_position() -> float:
	return audio_player.get_playback_position()

# Get current song duration in seconds
func get_current_song_length() -> float:
	if songs.is_empty() or current_song_index == -1:
		return 0.0
	return songs[current_song_index].get_length()
