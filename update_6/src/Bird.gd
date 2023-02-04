extends RigidBody2D

@export var jump_force: float = 10.

func _input(event: InputEvent):
	
	if event.is_action_pressed("action"):
		apply_force(Vector2.UP * jump_force, Vector2.UP)


var time: float = 0
var max_lim: float = 33. / 3.
var min_lim: float = 66.
var current_lim: float = randf_range(max_lim, min_lim)


func _physics_process(delta):
	time += delta
	if position.y > current_lim and time > .2:
		apply_force(Vector2.UP * jump_force, Vector2.UP)
		time = .0
		current_lim = randf_range(max_lim, min_lim)
