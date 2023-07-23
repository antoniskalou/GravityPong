extends Node

@export var players: Array[CharacterBody2D]

var players_with_lives
var current_player

func next_player(current: CharacterBody2D) -> Dictionary:
	var current_idx = players.find(current)
	return players_with_lives[(current_idx + 1) % players_with_lives.size()]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BallSpawner.spawn_randomly()
	players_with_lives = players.map(func (p): return { 'player': p, 'lives': 3 })
	current_player = players_with_lives[0]
	current_player['player'].movement_enabled = true
	for p in players:
		p.connect("paddle_hit", _on_paddle_hit)
	
	
func _on_paddle_hit(paddle: CharacterBody2D) -> void:
	if current_player['player'] == paddle:
		current_player['player'].movement_enabled = false
		current_player = next_player(current_player['player'])
		current_player['player'].movement_enabled = true
	else:
		# TODO: decide what to do when the ball hits a non-player
		pass


func _on_ball_left_scene(body: Node2D) -> void:
	current_player['lives'] -= 1
	print(current_player['player'].name, " lives left: ", current_player['lives'])
	if current_player['lives'] < 0:
		print("Game over! ", next_player(current_player['player'])['player'].name, " wins!")
	$BallSpawner.despawn_all()
	$BallSpawner.spawn_randomly()
