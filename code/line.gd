extends Line2D

var old_children

func _ready():
	old_children = get_children()

func update_line():
	if get_children() != old_children:
		for child in get_children():
			if child not in old_children:
				add_point(Vector2(child.position.x, child.position.y + 23))
		old_children = get_children()
