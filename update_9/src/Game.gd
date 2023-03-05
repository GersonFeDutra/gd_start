extends Node

@export var speed_growth_factor: float = 1.

## Taxa de velocidade (rapidez)
@export var default_speed: float = 1.
@onready var speed: float = default_speed

func _process(delta):
	# Aumenta a velocidade progressivamente em função do tempo (obtido em delta)
	speed += log(delta + 1) * speed_growth_factor


signal new_best_achieved

const MIN_PITCH: float = 1.
const MAX_PITCH: float = 1.75

var best_score: int = 0
var score: int = 0
@onready var score_sfx := $SFX as AudioStreamPlayer

func score_up():
	score += 1
	score_sfx.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	score_sfx.play()
	
	if score > best_score:
		best_score = score
		new_best_achieved.emit()


## Reseta os parâmetros do jogo
func reset():
	speed = default_speed
	score = 0
