@tool # Torna o código executável no editor
extends Area2D

## Variável do comportamento que atualiza a cena com base no valor de `gap`
var _gap_update: Callable = func(): pass
## Distância entre canos
@export_range(0., 67.) var gap: float = 0:
	set(value):
		_gap_update.call(value)
		gap = value

@onready var top: Sprite2D = $Top
@onready var top_shape: CollisionShape2D = $TopShape

func _ready():
	_gap_update = update_gap
	update_gap(gap)
	# Desativa o processamento no Editor
	set_process(not Engine.is_editor_hint())


const MOTION_OFFSET: float = 2.
@onready var virtual_posx = position.x

func _process(delta: float):
	var velocity_x := Game.speed * delta * MOTION_OFFSET
	# Velocidade atual do movimento no eixo-x
	
	virtual_posx -= velocity_x
	position.x = roundf(virtual_posx)
	
	if position.x < -top.region_rect.size.x:
		queue_free() # Deleta a instância de Pipe


signal scored
@onready var raycast := $RayCast2D as RayCast2D

func _physics_process(delta: float):
	if raycast.is_colliding():
		scored.emit()
		raycast.queue_free()
		get_tree().paused = true # Pausa o jogo


func update_gap(value: float):
	top.position.y = -(value + top.region_rect.size.y)
	top_shape.position.y = -(value + top_shape.shape.size.y / 2 + 1)
