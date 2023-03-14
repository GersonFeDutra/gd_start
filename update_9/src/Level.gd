extends Node2D

var is_new_best: bool = false

func _ready():
	
	Game.new_best_achieved.connect(func():
		if not is_new_best:
			$GUI/NewBest/AnimationPlayer.play("partial_blink")
			is_new_best = true
	)
	
	for path in freeze_node_paths:
		freeze_nodes.append(get_node(path))


@export var freeze_node_paths: Array[NodePath]
@export var freeze_nodes: Array[Node] = []

@export var new_score_sfx: AudioStreamWAV
@export var game_over_sfx: AudioStreamWAV

func _on_bird_died():
	var bird = $Bird
	bird.set_process_input(false)
	
	await get_tree().physics_frame # Aguarda a física ser processada
	
	for node in freeze_nodes:
		node.process_mode = Node.PROCESS_MODE_DISABLED
		# Para de processar o nó como se o jogo estivesse pausado para ele
	
	$GUI/AnimationPlayer.play("show_up")
	if is_new_best:
		$GUI/NewBest/AnimationPlayer.play("blink")
		$GUI/SFX.stream = new_score_sfx
		is_new_best = false
	else:
		$GUI/SFX.stream = game_over_sfx
	
	$GUI/SFX.play()


func new_game():
	Game.reset()
	get_tree().reload_current_scene()
