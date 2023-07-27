extends CharacterBody2D

signal paddle_hit(body: CharacterBody2D)

@export var speed := 800.0
@export var movement_enabled := true
@export var outline_color := Color.PURPLE
@export var outline_thickness := 3.0

@onready var outline_shader := preload("res://src/outline.gdshader")


func highlight(enabled: bool) -> void:
	if enabled:
		$Sprite2D.material = ShaderMaterial.new()
		$Sprite2D.material.shader = outline_shader
		$Sprite2D.material.set_shader_parameter('line_color', outline_color)
		$Sprite2D.material.set_shader_parameter('line_thickness', outline_thickness)
	else:
		$Sprite2D.material = null


func move(axis: float) -> void:
	velocity.x = axis * speed
	move_and_slide()


func _ready() -> void:
	highlight(false)


func _on_ball_hit_detector_body_entered(body: Node2D) -> void:
	$HitSound.play_random()
	paddle_hit.emit(self)
