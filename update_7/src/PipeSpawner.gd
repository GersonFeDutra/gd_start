extends Node2D

const SPAWN_POS: float = 45.
const Pipe = preload("res://src/Pipe.gd")
const PIPE_SCN: PackedScene = preload("res://src/pipe.tscn")

@export var gap_reduction: float = 0.01
@export var low_gap: float = 13.
@export var high_gap: float = 26.
@onready var current_gap: float = high_gap

@export var min_position: float = 26.
@export var max_position: float = 80. - 7. # Screen.height - Floor


func _ready():
	min_position = high_gap


@onready var timer: Timer = $Timer

const BASE_SPAWN_FREQ: float = 20.
const FREQ_DEC_DEG: float = 1.

@export_node_path("Sprite2D")
var floor_path: NodePath
@onready var floor_sprite := get_node(floor_path) as Sprite2D

@export_node_path("Label")
var score_path: NodePath
@onready var score_label := get_node(score_path) as Label
var score: int = 0

func spawn_pipe():
	var new_pipe: Pipe = PIPE_SCN.instantiate()
	var floor_virtual_posx := floor_sprite.get_meta("virtual_posx") as float
	
	new_pipe.position.x = SPAWN_POS + \
			floor_virtual_posx - int(floor_virtual_posx)
	new_pipe.position.y = roundf(randf_range(min_position, max_position))
	new_pipe.gap = roundf(current_gap)
	# Update Gap
	current_gap = maxf(lerpf(current_gap, low_gap, gap_reduction), low_gap)
	
	# Conecta-se ao evento "scored" pra atualizar a UI (Inteface do Usuário)
	new_pipe.scored.connect(func update_gui():
		score += 1
		score_label.text = str(score)
	)
	
	add_child(new_pipe)
	timer.start(BASE_SPAWN_FREQ * FREQ_DEC_DEG / (Game.speed + FREQ_DEC_DEG))
