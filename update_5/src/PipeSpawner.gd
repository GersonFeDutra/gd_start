extends Node2D

const SPAWN_POS: float = 80.
const Pipe = preload("res://src/Pipe.gd")
const PIPE_SCN: PackedScene = preload("res://src/pipe.tscn")

@export var gap_reduction: float = 0.1
@export var low_gap: float = 13.
@export var high_gap: float = 26.
@onready var current_gap: float = high_gap

@export var min_position: float = 26.
@export var max_position: float = 80. - 7. # Screen.height - Floor


func _ready():
	min_position = high_gap


func spawn_pipe():
	var new_pipe: Pipe = PIPE_SCN.instantiate()
	
	new_pipe.position.x = SPAWN_POS
	new_pipe.position.y = floorf(randf_range(min_position, max_position))
	new_pipe.gap = floorf(current_gap)
	
	# Update Gap
	current_gap = maxf(lerpf(current_gap, low_gap, gap_reduction), low_gap)
	
	add_child(new_pipe)
