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
	_set_lives($Play/HealthBar1, lives)


func player_2_set_lives(lives: int) -> void:
	_set_lives($Play/HealthBar2, lives)


func _set_lives(node: Node, lives: int) -> void:
	var life_delta = node.get_child_count() - lives
	if life_delta < 0: # add hearts
		for i in range(0, abs(life_delta)):
			node.add_child(heart_texture.duplicate())
	elif life_delta > 0: # remove hearts
		for i in range(0, life_delta):
			remove_first_child(node)

	
func remove_first_child(node: Node) -> void:
	node.remove_child(node.get_child(0))


func _on_play_again_pressed() -> void:
	start_game.emit()
