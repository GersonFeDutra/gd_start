extends Node

@export var speed_growth_factor: float = 1.
## Taxa de velocidade (rapidez)
var speed: float = 1.


func _process(delta):
	# Aumenta a velocidade progressivamente em função do tempo (obtido em delta)
	speed += log(delta + 1) * speed_growth_factor
