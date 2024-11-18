extends Camera3D

@onready var world = get_parent().get_parent()
@onready var origin = get_parent()

var cell
var mode = "view"
var viewtype = 1

func __rayfromcam() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 5000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if !raycast_result.has("position"): return Vector3(0,0,0)
	return raycast_result.position #global position of collision
	
func _input(event: InputEvent) -> void:
	cell = world.local_to_map(__rayfromcam())
	
	if Input.is_action_just_pressed("+b"):
		mode = "build"
		world.cursor.visible = true
	if Input.is_action_just_pressed("+v"):
		mode = "view"
		world.cursor.visible = false
	
	match mode:
		"view":
			if event is InputEventMouseMotion: 
				if viewtype == 0:
					if Input.is_action_pressed("mouse1"):
						origin.global_position.x += (-event.relative.x) * 0.025
						origin.global_position.z -= (-event.relative.x) * 0.025
						#origin.global_position.y += (event.relative.y) * 0.025
					if Input.is_action_pressed("wheel"):
						origin.rotation.x -= event.relative.y * 0.01
				if viewtype == 1:
					if Input.is_action_pressed("mouse1"):
						origin.rotation.x -= event.relative.y * 0.01
						origin.rotate_y(-event.relative.x * 0.01)
					if Input.is_action_pressed("mouse2"):
						origin.global_position += origin.transform.basis.x * (-event.relative.x) * 0.1
						if origin.rotation.x > 0.5:
							origin.global_position += (origin.transform.basis.y * (-event.relative.y) * 0.1) * Vector3(1,0,1)
						else:
							origin.global_position += (origin.transform.basis.z * (-event.relative.y) * 0.1) * Vector3(1,1,1)
			
			if Input.is_action_just_pressed("+wheel"):
				fov -= 1
			if Input.is_action_just_pressed("-wheel"):
				fov += 1
			
			fov = clampf(fov, 15.0, 33.0)
			origin.rotation_degrees.x = clampf(origin.rotation_degrees.x, -0.01, 64.8)
		"build":
			world.__update3dcursor(cell)
			#print(world.__getcelltype(cell))
			
			if Input.is_action_just_pressed("mouse1"):
				world._getsurroundingcells(cell)
			
