extends CanvasLayer


signal start_game


func game_start() -> void:
	$GameOver.hide()
	$Play.show()
	

func game_over(winner: String) -> void:
	$GameOver.show()
	$Play.hide()
	$GameOver/Winner.text = winner + " wins!"


func player_1_set_lives(lives: int) -> void:
	$Play/HealthBar1.lives = lives


func player_2_set_lives(lives: int) -> void:
	$Play/HealthBar2.lives = lives



func _on_play_again_pressed() -> void:
	start_game.emit()
