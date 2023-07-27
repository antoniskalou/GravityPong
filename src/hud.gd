extends CanvasLayer


signal start_single_player
signal start_multi_player
signal restart_game


var spawn_timer: Timer


func show_timeout(timer: Timer):
	spawn_timer = timer
	$Play/SpawnCountdown.show()


func main_menu() -> void:
	$MainMenu.show()
	# enable browsing with the gamepad
	# see https://www.reddit.com/r/godot/comments/6q4q29/comment/dkxl13v/
	$MainMenu/Options/SinglePlayer.grab_focus()
	$GameOver.hide()
	$Play.hide()


func game_start() -> void:
	$MainMenu.hide()
	$GameOver.hide()
	$Play.show()
	

func game_over(winner: String, color: Color) -> void:
	$MainMenu.hide()
	$GameOver.show()
	$GameOver/Options/PlayAgain.grab_focus()
	$Play.hide()
	$GameOver/Winner.text = winner + " wins!"
	$GameOver/Winner.modulate = color


func player_1_set_lives(lives: int) -> void:
	$Play/HealthBar1.lives = lives


func player_2_set_lives(lives: int) -> void:
	$Play/HealthBar2.lives = lives


func _process(delta: float) -> void:
	# is there a better way to do this? perhaps with await?
	if spawn_timer:
		$Play/SpawnCountdown.text = "%.2f" % [spawn_timer.time_left]
		if spawn_timer.is_stopped():
			$Play/SpawnCountdown.hide()
			spawn_timer = null
	

func _on_play_again_pressed() -> void:
	restart_game.emit()


func _on_single_player_pressed() -> void:
	start_single_player.emit()


func _on_multi_player_pressed() -> void:
	start_multi_player.emit()


func _on_main_menu_pressed() -> void:
	# for now its fine to return to main menu, the game state will remain valid
	# and when Single/Multi Player is clicked, the game state will be reset
	main_menu()


func _on_audio_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not button_pressed)
