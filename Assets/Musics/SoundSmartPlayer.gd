extends AudioStreamPlayer2D

func init_player(audioClip: AudioStream):
	stream = audioClip
	play()

func finished():
	queue_free()
