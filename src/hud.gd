extends CanvasLayer


signal start_game

# TODO: export this as Texture2D in custom HealthBar node
@onready var heart_texture: TextureRect = $Play/HealthBar1/Heart


func game_start() -> void:
	$GameOver.hide()
	$Play.show()
	

func game_over() -> void:
	$GameOver.show()
	$Play.hide()


func player_1_set_lives(lives: int) -> void:
	$Play/HealthBar1.lives = lives


func player_2_set_lives(lives: int) -> void:
	$Play/HealthBar2.lives = lives



func _on_play_again_pressed() -> void:
	start_game.emit()
