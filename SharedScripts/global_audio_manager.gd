extends AudioStreamPlayer2D

var current_music_track : AudioStream

func play_track(new_stream: AudioStream, volume):
	if stream != new_stream:
		stream = new_stream
	volume_db = volume
	play()

func play_SFX(new_stream: AudioStream, volume):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = new_stream
	sfx_player.volume_db = volume
	sfx_player.name = "SFX_Instance"
	add_child(sfx_player)
	sfx_player.play()
	
	await sfx_player.finished
	sfx_player.queue_free()
