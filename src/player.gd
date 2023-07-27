extends Node2D

signal player_hit(Node2D)

@export var movement_enabled := true
@export var moves: Array[StringName]
@export var start_lives := 3

var lives := start_lives


func reset_lives() -> void:
	lives = start_lives


func loose_life() -> int:
	lives -= 1
	return lives


func highlight(enabled: bool) -> void:
	$Paddle.highlight(enabled)


func _process(delta: float) -> void:
	if movement_enabled:
		$Paddle.move(Input.get_axis(moves[0], moves[1]))


func _on_paddle_hit(body: Node2D) -> void:
	player_hit.emit(self)
