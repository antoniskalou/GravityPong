extends Node

@export var players: Array[CharacterBody2D]

var lives: Array
var current_player: CharacterBody2D


func player_loose_life(player: CharacterBody2D) -> void:
	var current_idx = players.find(player)
	lives[current_idx] -= 1


func lives_for_player(player: CharacterBody2D) -> int:
	var current_idx = players.find(player)
	return lives[current_idx]


func next_player(current: CharacterBody2D) -> CharacterBody2D:
	var current_idx = players.find(current)
	return players[(current_idx + 1) % players.size()]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BallSpawner.spawn_randomly()
	lives = players.map(func (p): return 3)
	current_player = players[0]
	current_player.movement_enabled = true
	for p in players:
		p.connect("paddle_hit", _on_paddle_hit)
	
	
func _on_paddle_hit(paddle: CharacterBody2D) -> void:
	if current_player == paddle:
		current_player.movement_enabled = false
		current_player = next_player(current_player)
		current_player.movement_enabled = true
	else:
		# TODO: decide what to do when the ball hits a non-player
		pass


func _on_ball_left_scene(body: Node2D) -> void:
	player_loose_life(current_player)
	print(current_player.name, " lives left: ", lives_for_player(current_player))
	if lives_for_player(current_player) < 0:
		print("Game over! ", next_player(current_player).name, " wins!")
	$BallSpawner.despawn_all()
	$BallSpawner.spawn_randomly()
