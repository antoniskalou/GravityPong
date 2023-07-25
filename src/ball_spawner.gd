extends Area2D
class_name BallSpawner

const BallScene: = preload("res://src/ball.tscn") as PackedScene

@export var min_speed := -400.0
@export var max_speed := 400.0

# can safely assume shape will always exist, since warning is shown to user
# if they don't add a collision shape
#
# will also assume its a rectangle...
@onready var spawn_area: RectangleShape2D = shape_owner_get_shape(0, 0)


func _ready() -> void:
	if not spawn_area is RectangleShape2D:
		push_warning("Child collider must be a rectangle shape. Spawn will fail!")

# TESTING ONLY!! used for spawning a whole bunch of balls
# func _process(delta: float) -> void:
#       spawn_randomly()

func spawn(position: Vector2, velocity: Vector2) -> Node2D:
	var ball = BallScene.instantiate()
	ball.position = position
	ball.velocity = velocity
	call_deferred("add_child", ball)
	return ball


func spawn_randomly() -> Node2D:
	var position = position_to_spawn(spawn_area)
	var speed = randi_range(min_speed, max_speed)
	var velocity = Vector2(speed, 0)
	return spawn(position, velocity)


func despawn(ball: Node2D) -> void:
	remove_child(ball)
	ball.queue_free()


func despawn_all() -> void:
	for ball in spawned():
		despawn(ball)


## returns a list of all spawned objects
func spawned() -> Array:
	# spawned objects aren't owned by this node
	return find_children("*", "CharacterBody2D", false, false)


func position_to_spawn(shape: RectangleShape2D) -> Vector2:
	var pos_min = position
	var pos_max = pos_min + shape.size
	return Vector2(
		randi_range(pos_min.x, pos_max.x),
		randi_range(pos_min.y, pos_max.y)
	)
