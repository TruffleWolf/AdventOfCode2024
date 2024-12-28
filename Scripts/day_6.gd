extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day6input.txt",FileAccess.READ)
@onready var detector_scene:PackedScene = preload("res://Objects/Day6/guard_box.tscn")
@onready var guard_scene:PackedScene = preload("res://Objects/Day6/guard_body.tscn")
@onready var blocker_scene:PackedScene = preload("res://Objects/Day6/blocker.tscn")
var total_grid:Array = []
var detector_list:Array = []
var relevant_grid:Array = []
var start_location:Vector2i

func _ready():
	var start_time:int = Time.get_ticks_msec()
	#format the data
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		var new_line:Array = []
		for a in row:
			new_line.append(false)
		relevant_grid.append(new_line)
		total_grid.append(row)
	
	
	#Delete junk line
	total_grid.resize(total_grid.size()-1)
	
	#find the starting location
	get_start_pos()
	#find the relevant squares
	relevance_solver()
	
	
	
	#part 1
	#part_one()
	#var total:int = 0
	#for y in relevant_grid:
		#for x in y:
			#total+=int(x)
	#
	#print("Total:"+str(total))
	#part 2
	part_two()
	
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")

func part_two():
	#yeah I don't know if 3d will cut it for this one
	#clear the start location
	relevant_grid[start_location.y][start_location.x]= false
	
	
	var total:int = 0
	var y:int = 0
	for t in total_grid:
		var x:int = 0
		for s in t:
			
			if relevant_grid[y][x]:
				var test_grid:Array = total_grid.duplicate(true)
				
				test_grid[y][x]="#"
				print(test_grid[y][x])
				total+=int(loop_check(test_grid))
				
			x+=1
		y+=1
	
	print(total)

#somehow I found a slower way to do this than the 3d physics sim.
func loop_check(input:Array) -> bool:
	#lets not count forever if we can avoid it
	var count:int = 0
	var current_location:Vector2i = start_location
	var direction:Vector2i = Vector2i(0,-1)
	var known_transforms:Array[Vector4i] = []
	while count < 999999999999:
		var current_transform:Vector4i = Vector4i(current_location.x,current_location.y,direction.x,direction.y)
		
		if known_transforms.has(current_transform):
			return true
		known_transforms.append(current_transform)
		
		var new_location:Vector2i = current_location+direction
		if new_location.x<0 or new_location.y <0 or new_location.x>input[0].size()-1 or new_location.y>input.size()-1:
			return false
		elif input[new_location.y][new_location.x]=="#":
			direction = rotate_vec2i(direction)
		else:
			current_location = new_location
		
		count +=1
	
	
	#yeah something broke if you get here
	print("WHILE TIMEOUT")
	get_tree().quit(1)
	return true

func get_start_pos():
	var y:int = 0
	for t in total_grid:
		var x:int = 0
		for s in t:
			if s == "^":
				start_location = Vector2i(x,y)
				return
			x+=1
		y+=1

func relevance_solver():
	#you can use this to solve part one instead of the 3d version
	var in_bounds:bool = true
	var current_location:Vector2i = start_location
	var direction:Vector2i = Vector2i(0,-1)
	while in_bounds:
		
		relevant_grid[current_location.y][current_location.x] = true
		var new_location:Vector2i = current_location+direction
		if new_location.x<0 or new_location.y <0 or new_location.x>total_grid[0].size()-1 or new_location.y>total_grid.size()-1:
			in_bounds = false
			break
		elif total_grid[new_location.y][new_location.x]=="#":
			direction = rotate_vec2i(direction)
		else:
			current_location = new_location


func rotate_vec2i(input:Vector2i):
	#we use this instead of the build in vec2.rotate to avoid floating point errors
	var new_vec:Vector2i = Vector2i(0,0)
	new_vec.x = input.y*-1
	new_vec.y = input.x
	
	return new_vec

func part_one():
	#lets do it in 3d for the bit
	$Node3D/Floor/CollisionShape3D.shape.size.x = total_grid.size()+1
	$Node3D/Floor/CollisionShape3D.shape.size.z = total_grid[0].size()+1
	$Node3D/Floor/CollisionShape3D.position.x = (total_grid.size()+1)/2
	$Node3D/Floor/CollisionShape3D.position.z = (total_grid[0].size()+1)/2
	$Node3D/Floor/CollisionShape3D/MeshInstance3D.mesh.size.x = total_grid.size()+1
	$Node3D/Floor/CollisionShape3D/MeshInstance3D.mesh.size.z = total_grid[0].size()+1
	
	var y:int = 0
	for t in total_grid:
		var x:int = 0
		for s in t:
			if s == "^":
				var new_guard = guard_scene.instantiate()
				new_guard.transform.origin = Vector3(x,0,y)
				new_guard.controller = self
				$Node3D.add_child(new_guard)
				var new_detector = detector_scene.instantiate()
				new_detector.transform.origin = Vector3(x,0,y)
				$Node3D.add_child(new_detector)
				detector_list.append(new_detector)
			elif s == "#":
				var new_blocker = blocker_scene.instantiate()
				new_blocker.transform.origin = Vector3(x,0,y)
				$Node3D.add_child(new_blocker)
			else:
				var new_detector = detector_scene.instantiate()
				new_detector.transform.origin = Vector3(x,0,y)
				$Node3D.add_child(new_detector)
				detector_list.append(new_detector)
			
			x+=1
		y+=1
	


func get_total_travel():
	var total:int = 0
	
	for d in detector_list:
		total += int(d.entered)
	
	print("total:"+str(total))
