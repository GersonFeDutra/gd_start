extends Node2D

signal bird_died

const SPAWN_POS: float = 45.
const Pipe = preload("res://src/Pipe.gd")
const PIPE_SCN: PackedScene = preload("res://src/pipe.tscn")

## Spawn frequency
const BASE_SPAWN_FREQ: float = 20.
const FREQ_DEC_DEG: float = 1.
@onready var timer := $Timer as Timer

## Gap
@export var gap_reduction: float = 0.01
@export var low_gap: float = 13.
@export var high_gap: float = 26.
@onready var current_gap: float = high_gap

## Position offset
@export var min_position: float = 26.
@export var max_position: float = 80. - 7. # Screen.height - Floor

# No editor será exportado o path usado pra carregar a instância automaticamente
@export var floor_sprite: Sprite2D
@export var floor_area: Area2D
@export var score_label: Label

# Bird instance
const Bird = preload("res://src/Bird.gd")
@export_node_path("PhysicsBody2D")
var bird_path: NodePath
@onready var bird := get_node(bird_path) as Bird


func _ready():
	min_position = high_gap


@export var pipe_collide_sfx: AudioStreamWAV
@export var floor_collide_sfx: AudioStreamWAV

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
		Game.score_up()
		score_label.text = str(Game.score)
	)
	# Conecta-se ao evento "body entered" para resetar o Game Loop
	new_pipe.body_entered.connect(func(_arg):
		bird.apply_impulse(Vector2.LEFT * .2, Vector2.LEFT)
		play_sfx(pipe_collide_sfx)
		bird_died.emit()
	)
	floor_area.body_entered.connect(func(_arg):
		bird.apply_impulse(Vector2.UP * .2, Vector2(randf_range(-1, 1), -1))
		bird.set_process_input(false)
		floor_area.queue_free()
		play_sfx(floor_collide_sfx)
		bird_died.emit()
	)
	
	add_child(new_pipe)
	timer.start(BASE_SPAWN_FREQ * FREQ_DEC_DEG / (Game.speed + FREQ_DEC_DEG))


const MIN_PITCH: float = .75
const MAX_PITCH: float = 1.2

@onready var sfx_player := $SFX as AudioStreamPlayer

func play_sfx(stream: AudioStreamWAV):
	sfx_player.stream = stream
	sfx_player.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
	sfx_player.play()
