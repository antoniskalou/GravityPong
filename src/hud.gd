extends CanvasLayer


signal start_single_player
signal start_multi_player
signal restart_game


func main_menu() -> void:
	$MainMenu.show()
	$GameOver.hide()
	$Play.hide()


func game_start() -> void:
	$MainMenu.hide()
	$GameOver.hide()
	$Play.show()
	

func game_over(winner: String, color: Color) -> void:
	$MainMenu.hide()
	$GameOver.show()
	$Play.hide()
	$GameOver/Winner.text = winner + " wins!"
	$GameOver/Winner.modulate = color


func player_1_set_lives(lives: int) -> void:
	$Play/HealthBar1.lives = lives


func player_2_set_lives(lives: int) -> void:
	$Play/HealthBar2.lives = lives


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
