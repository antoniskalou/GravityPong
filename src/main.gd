extends Node

@export var player_1: Node2D
@export var player_2: Node2D

@export var player_1_moves: Array[StringName] = ["move_left", "move_right"]
@export var player_2_moves: Array[StringName] = ["move_left_2", "move_right_2"]

@onready var players: Array[Node2D] = [player_1, player_2]
@onready var current_player: Node2D = players[0]


func game_start():
	$HUD.game_start()
	player_1.reset_lives()
	player_2.reset_lives()
	$HUD.player_1_set_lives(player_1.lives)
	$HUD.player_2_set_lives(player_2.lives)
	$BallSpawner.spawn_randomly()
	# loser plays first
	current_player.movement_enabled = true
	current_player.highlight(true)
	

func start_single_player():
	game_start()
	# player 1 controls both
	player_1.moves = player_1_moves
	player_2.moves = player_1_moves
	

func start_multi_player():
	game_start()
	player_1.moves = player_1_moves
	player_2.moves = player_2_moves


func game_over():
	# winner is the one that isn't playing, since the loser (current_player) 
	# would have made the losing shot
	var winner = next_player(current_player)
	var winner_name = 'Player 1' if winner == player_1 else 'Player 2'
	$HUD.game_over(winner_name, winner.modulate)
	

func next_player(current: Node) -> CharacterBody2D:
	var current_idx = players.find(current)
	return players[(current_idx + 1) % players.size()]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for p in players:
		p.connect("player_hit", _on_player_hit)
	$HUD.main_menu()
	
	
func _on_player_hit(player: Node2D) -> void:
	if current_player == player:
		current_player.movement_enabled = false
		current_player.highlight(false)
		current_player = next_player(current_player)
		current_player.movement_enabled = true
		current_player.highlight(true)
	else:
		# hitting other player does nothing
		pass


func _on_ball_left_scene(body: Node2D) -> void:
	var lives = current_player.loose_life()
	# update lives in score
	if current_player == player_1:
		$HUD.player_1_set_lives(lives)
	else:
		$HUD.player_2_set_lives(lives)
	if lives < 0:
		game_over()
	else:
		$BallSpawner.despawn_all()
		spawn_delayed($SpawnTimer)


func spawn_delayed(timer: Timer):
	timer.start()
	$HUD.show_timeout(timer)
	await timer.timeout
	$BallSpawner.spawn_randomly()


func _on_hud_restart_game() -> void:
	game_start()


func _on_hud_start_single_player() -> void:
	start_single_player()


func _on_hud_start_multi_player() -> void:
	start_multi_player()
