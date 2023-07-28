extends AudioStreamPlayer
class_name TimedAudioPlayer

const LOWEST_DECIBEL := -80.0

## Duration the each track should play for, in seconds
@export var track_duration := 5.0 * 60.0 # 5 minutes
## Duration it takes to fade track in and out, in seconds
@export var fade_duration := 3.0
@export var audio_files: Array[AudioStream]

@onready var play_timer := Timer.new()
var default_volume_db: float


func _ready() -> void:
	default_volume_db = self.volume_db
	# disable looping, SFX usually don't loop
	for audio in audio_files:
		if audio.get("loop") != null:
			audio.loop = true
		# WAV format is different for some reason
		elif audio.get("loop_mode") != null:
			audio.loop_mode = AudioStreamWAV.LOOP_FORWARD
		else:
			push_error("Unsupported audio stream type: %s" % [audio.get_class()])
	# we need to add the timer to the scene, the other timer only does oneshot
	play_timer.wait_time = track_duration
	play_timer.connect("timeout", _on_timeout)
	play_timer.autostart = true
	add_child(play_timer)
	# start playback
	switch_track(audio_files.pick_random())


func _on_timeout() -> void:
	print("Switching track")
	switch_track(audio_files.pick_random())
	
	
func switch_track(track: AudioStream) -> void:
	var tween = get_tree().create_tween()
	# fade out current track
	if is_playing():
		# half fade duration taken here, half later
		tween_volume(tween, LOWEST_DECIBEL, fade_duration / 2.0)
		tween.tween_callback(stop)
	# start next track
	tween.tween_callback(func (): stream = track)
	tween.tween_callback(play)
	tween_volume(tween, default_volume_db, fade_duration / 2.0)


func tween_volume(tween: Tween, volume_db: float, seconds: float):
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "volume_db", volume_db, seconds)
