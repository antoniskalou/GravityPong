@tool
@icon("res://assets/icons/hearts.png")
extends HBoxContainer
class_name HealthBar


@export var heartTexture: Texture2D
@export var heartColor: Color
@export var lives: int = 3: set = _set_lives


func _set_lives(new_lives: int) -> void:
	lives = new_lives
	var life_delta = get_child_count() - lives
	for i in range(0, abs(life_delta)):
		if life_delta < 0: # add hearts
			var texture = TextureRect.new()
			texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			texture.modulate = heartColor
			texture.texture = heartTexture
			add_child(texture)
		elif life_delta > 0: # remove hearts
			remove_first_child(self)

	
func remove_first_child(node: Node) -> void:
	if node.get_child_count() > 0:
		node.remove_child(node.get_child(0))
