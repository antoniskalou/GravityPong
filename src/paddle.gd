extends CharacterBody2D

signal paddle_hit(body: CharacterBody2D)

@export var speed := 700.0
@export var movement_enabled := true


func _physics_process(delta: float) -> void:
	if movement_enabled:
		var movement := Input.get_axis("move_left", "move_right")
		velocity.x = movement * speed
	move_and_slide()


func _on_ball_hit_detector_body_entered(body: Node2D) -> void:
	paddle_hit.emit(self)
