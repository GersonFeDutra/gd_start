extends Node2D

## A lista de filhos do nó
## Assume que todos os filhos são Node2D
@onready var children: Array[Node2D] = []

# _ready é chamado quando o nó entra na árvore da cena pela primeira vez.
func _ready():
	
	for child in get_children(): # filhos
		var offset: float = child.get_meta("loop_offset")
		
		for grandchild in child.get_children(): # netos
			var copy: Node2D = grandchild.duplicate() # Duplica um neto
			
			grandchild.set_meta("virtual_posx", grandchild.position.x)
			copy.set_meta("virtual_posx", offset) # Posição "virtual"
			copy.position.x = floorf(offset)     # Posiciona a cópia (fixed-pxl)
			
			grandchild.add_sibling(copy)
			# Adiciona a cópia como um "irmão" logo abaixo do neto
			# o nó adicionado deve ser órfão antes da chamada
		
		children.append(child) # Salva os filhos na lista `children`

var speed: float = 1.0 ## Taxa de velocidade (rapidez)

# Chamado a cada frame. 'delta' é o tempo passado desde o último frame.
func _process(delta):
	# Velocidade atual do movimento no eixo-x
	var velocity_x: float = speed * delta
	# Move os Sprites com base na velocidade atual
	
	for child in children:
		var offset: float = child.get_meta("loop_offset")
		
		for grandchild in child.get_children():
			var new_pos := grandchild.get_meta("virtual_posx") as float - \
					velocity_x * grandchild.get_meta("motion_offset") as float
			var end_pos := new_pos + offset
			
			if end_pos < 0:
				# end_pos será o quanto de espaço em x ultrapassou o eixo y
				new_pos = offset + end_pos
			
			grandchild.set_meta("virtual_posx", new_pos)
			grandchild.position.x = roundf(new_pos)
	
	speed += delta # Aumenta a velocidade progressivamente
