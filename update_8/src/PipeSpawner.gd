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

@onready var timer: Timer = $Timer

const BASE_SPAWN_FREQ: float = 20.
const FREQ_DEC_DEG: float = 1.

@export_node_path("Sprite2D")
var floor_path: NodePath
@onready var floor_sprite := get_node(floor_path) as Sprite2D

# No editor será exportado o path usado pra carregar a instância automaticamente
@export var score_label: Label

const Bird = preload("res://src/Bird.gd")
@export_node_path("PhysicsBody2D")
var bird_path: NodePath
@onready var bird := get_node(bird_path) as Bird

@export var freeze_node_paths: Array[NodePath]
@export var freeze_nodes: Array[Node] = []


func _ready():
	for path in freeze_node_paths:
		freeze_nodes.append(get_node(path))
	
	min_position = high_gap

@export var floor_area: Area2D

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
		Game.score += 1
		score_label.text = str(Game.score)
	)
	
	# Conecta-se ao evento "body entered" para resetar o Game Loop
	new_pipe.body_entered.connect(func(_arg):
		bird.apply_impulse(Vector2.LEFT * .2, Vector2.LEFT)
		restart()
	)
	floor_area.body_entered.connect(func(_arg):
		bird.apply_impulse(Vector2.UP * .2, Vector2(randf_range(-1, 1), -1))
		bird.set_process_input(false)
		floor_area.queue_free()
		restart()
	)
	
	add_child(new_pipe)
	timer.start(BASE_SPAWN_FREQ * FREQ_DEC_DEG / (Game.speed + FREQ_DEC_DEG))


@export var anim_player: AnimationPlayer

func restart():
	bird.set_process_input(false)
	bird.jump_auto = func(_arg): pass
	
	await get_tree().physics_frame # Aguarda a física ser processada
	
	for node in freeze_nodes:
		node.process_mode = Node.PROCESS_MODE_DISABLED
		# Para de processar o nó como se o jogo estivesse pausado para ele
	
	anim_player.play("show_up")
