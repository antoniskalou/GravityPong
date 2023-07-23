extends Node

@export var players: Array[CharacterBody2D]

var current_player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_player = players[0]
	current_player.movement_enabled = true
	for p in players:
		p.connect("paddle_hit", _on_paddle_hit)
	
	
func _on_paddle_hit(paddle: CharacterBody2D):
	if current_player == paddle:
		current_player.movement_enabled = false
		var current_idx = players.find(current_player)
		current_player = players[(current_idx + 1) % players.size()]
		current_player.movement_enabled = true
	else:
		# TODO: decide what to do when the ball hits a non-player
		pass
