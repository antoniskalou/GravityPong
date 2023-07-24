extends Node

@export var player_1: CharacterBody2D
@export var player_2: CharacterBody2D

@onready var players: Array[CharacterBody2D] = [player_1, player_2]
@onready var lives: Array = players.map(func(p): return 3)
@onready var current_player: CharacterBody2D = players[0]


func game_start():
	$HUD.game_start()
	lives = players.map(func(p): return 3)
	$HUD.player_1_set_lives(lives[0])
	$HUD.player_2_set_lives(lives[1])
	$BallSpawner.spawn_randomly()
	current_player.movement_enabled = true
	

func game_over():
	var winner = 'Player 1' if current_player == player_1 else 'Player 2'
	$HUD.game_over(winner)
	

func player_loose_life(player: CharacterBody2D) -> int:
	var current_idx = players.find(player)
	lives[current_idx] -= 1
	return lives[current_idx]


func lives_for_player(player: CharacterBody2D) -> int:
	var current_idx = players.find(player)
	return lives[current_idx]


func next_player(current: CharacterBody2D) -> CharacterBody2D:
	var current_idx = players.find(current)
	return players[(current_idx + 1) % players.size()]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for p in players:
		p.connect("paddle_hit", _on_paddle_hit)
	game_start()
	
	
func _on_paddle_hit(paddle: CharacterBody2D) -> void:
	if current_player == paddle:
		current_player.movement_enabled = false
		current_player = next_player(current_player)
		current_player.movement_enabled = true
	else:
		# TODO: decide what to do when the ball hits a non-player
		pass


func _on_ball_left_scene(body: Node2D) -> void:
	var lives = player_loose_life(current_player)
	# update lives in score
	if current_player == player_1:
		$HUD.player_1_set_lives(lives)
	else:
		$HUD.player_2_set_lives(lives)
	if lives < 0:
		game_over()
	else:
		$BallSpawner.despawn_all()
		$BallSpawner.spawn_randomly()


func _on_hud_start_game() -> void:
	game_start()
