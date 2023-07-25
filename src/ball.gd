extends CharacterBody2D

# Max angle at
@export var max_angle: int = 45

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().is_in_group('paddle'):
			velocity = deflect_from_paddle(collision)


func deflect_from_paddle(collision: KinematicCollision2D) -> Vector2:
	var paddle_shape = collision.get_collider_shape().shape
	var paddle_width = paddle_shape.size.x
	var paddle_x = collision.get_collider().global_position.x
	var hit_x = collision.get_position().x
	# distance from center of paddle as range between 0 and 1
	var distance_from_center = (hit_x - paddle_x + paddle_width / 2) / paddle_width
	# avoid bugs when hitting side of paddle
	distance_from_center = clampf(distance_from_center, 0, 1)
	# set to range between -1 and 1
	distance_from_center = (2 * distance_from_center) - 1
	print("Distance from center: ", distance_from_center)
	var angle_change = distance_from_center * max_angle
	return velocity.rotated(deg_to_rad(angle_change))
