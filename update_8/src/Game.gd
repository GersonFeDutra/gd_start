extends Node

@export var speed_growth_factor: float = 1.

## Taxa de velocidade (rapidez)
@export var default_speed: float = 1.
@onready var speed: float = default_speed


func _process(delta):
	# Aumenta a velocidade progressivamente em função do tempo (obtido em delta)
	speed += log(delta + 1) * speed_growth_factor


signal new_best_achieved
var best_score: int
var score: int = 0

## Reseta os parâmetros do jogo
func reset():
	speed = default_speed
	score = 0
	
	if score > best_score:
		best_score = score
		new_best_achieved.emit()
