extends RigidBody2D

@export var jump_force: float = 10.

func _input(event: InputEvent):
	
	if event.is_action_pressed("action"):
		apply_force(Vector2.UP * jump_force, Vector2.UP)
