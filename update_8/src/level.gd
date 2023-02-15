extends Node2D


func new_game():
	Game.reset()
	get_tree().reload_current_scene()
