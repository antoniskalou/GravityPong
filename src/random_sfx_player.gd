extends AudioStreamPlayer
class_name RandomSFXPlayer

@export var audio_files: Array[AudioStream]


func _ready() -> void:
	# disable looping, SFX usually don't loop
	for audio in audio_files:
		if audio.get("loop") != null:
			audio.loop = false
		# WAV format is different for some reason
		elif audio.get("loop_mode") != null:
			audio.loop_mode = AudioStreamWAV.LOOP_DISABLED
		else:
			push_error("Unsupported audio stream type: %s" % [audio.get_class()])


func play_random() -> void:
	stop()
	stream = audio_files.pick_random()
	play()
