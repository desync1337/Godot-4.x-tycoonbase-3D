extends GridMap

@onready var cursor = get_node("3dcursor")

var rng = RandomNumberGenerator.new()

func __getcelltype(cell) -> int:
	return get_cell_item(cell)
	
func __update3dcursor(cell):
	cursor.global_position = map_to_local(cell)
	cursor.global_position.y = 5
	
	if __getcelltype(cell) == -1:
		cursor.material.albedo_color = Color(1.0,0.0,0.0,0.5)
	else:
		cursor.material.albedo_color = Color(0.0,1.0,0.0,0.5)

func _init() -> void:
	generateworld(null)

func _getsurroundingcells(cell):
	var middle = cell
	var front = Vector3i(cell.x,cell.y,cell.z - 1)
	var back = Vector3i(cell.x,cell.y,cell.z + 1)
	var left = Vector3i(cell.x -1,cell.y,cell.z)
	var right = Vector3i(cell.x +1,cell.y,cell.z)
	
	print("\n\n\nfront: ",__getcelltype(front),
		"\nback: ", __getcelltype(back),
		"\nleft: ", __getcelltype(left),
		"\nright: ", __getcelltype(right),
		"\nself: ", __getcelltype(middle))

func generateworld(seed):
	if !seed: rng.randomize()
	else: rng.seed = seed
	
	var maxcraziness = 2
	var maxdistance =4
	
	for x in range(32):
		for y in range(32):
			var dist = Vector2i(x,y).distance_to(Vector2i(16,16))
			#var percentage = rng.randf_range(0.0,1.0)
			
			if dist < maxdistance - rng.randf_range(0.1,maxcraziness):
				set_cell_item(Vector3i(x - 16,0,y  - 16),0)
				print(dist)
