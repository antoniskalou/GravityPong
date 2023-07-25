extends CharacterBody2D

signal paddle_hit(body: CharacterBody2D)

@export var speed := 800.0
@export var movement_enabled := true


func move(axis: float) -> void:
	velocity.x = axis * speed
	move_and_slide()


func _on_ball_hit_detector_body_entered(body: Node2D) -> void:
	$HitSound.play_random()
	paddle_hit.emit(self)
