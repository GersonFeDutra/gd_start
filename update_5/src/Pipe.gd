@tool # Torna o código executável no editor
extends Area2D

## Variável do comportamento que atualiza a cena com base no valor de `gap`
var _gap_update: Callable = func(_arg): pass
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


signal deadzone_reached
var speed: float = 1.0

func _process(delta: float):
	var velocity_x := speed * delta
	position.x -= velocity_x * 2.
	
	if position.x < -top.region_rect.size.x:
		deadzone_reached.emit()
		queue_free() # Deleta a instância de Pipe
	
	speed += delta


func update_gap(value: float):
	top.position.y = -(value + top.region_rect.size.y)
	top_shape.position.y = -(value + top_shape.shape.size.y / 2 + 1)
