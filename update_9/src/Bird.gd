extends RigidBody2D

const MIN_PITCH: float = .75
const MAX_PITCH: float = 1.2

@export var jump_force: float = 10.
@onready var sfx_player := $SFX as AudioStreamPlayer

func _input(event: InputEvent):
	
	if event.is_action_pressed("action"): # Jump
		apply_force(Vector2.UP * jump_force, Vector2.UP)
		sfx_player.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
		sfx_player.play()


var time: float = 0
var max_lim: float = 33. / 3.
var min_lim: float = 66.
var current_lim: float = randf_range(max_lim, min_lim)
var jump_auto: Callable = auto_jump


func auto_jump(delta: float):
	time += delta
	
#	if time > .2:
	if position.y > current_lim and time > .22:
		apply_force(Vector2.UP * jump_force, Vector2.UP)
		time = .0
		current_lim = randf_range(max_lim, min_lim)
		sfx_player.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
		sfx_player.play()
 

const ANIM_THRESHOLD: float = 3.
enum States { IDLE = 0, JUMP, FALL, }
@onready var sprite := $Sprite as Sprite2D

func _physics_process(delta):
#	jump_auto.call(delta)
	
	if linear_velocity.y < -ANIM_THRESHOLD:
		sprite.frame = int(States.JUMP)
	elif linear_velocity.y > ANIM_THRESHOLD:
		sprite.frame = int(States.FALL)
	else:
		sprite.frame = int(States.IDLE)
