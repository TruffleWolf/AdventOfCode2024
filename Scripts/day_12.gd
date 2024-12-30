extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day12input.txt",FileAccess.READ)


var total_grid:Array = []
var parsed_grid:Array = []

#key is origin coords of the region, value is an array with index 0 as the letter, 1 as the area, 2 as the perimeter, 3 as the sides
var regions:Dictionary = {}

var parsed_fences:Array[Vector3i] = []

func _ready():
	var start_time:int = Time.get_ticks_msec()
	#parse the document
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		var new_array:Array
		for r in row:
			new_array.append(false)
		
		parsed_grid.append(new_array)
		total_grid.append(row)
	
	
	#Delete junk line
	total_grid.resize(total_grid.size()-1)
	parsed_grid.resize(parsed_grid.size()-1)
	
	#parse the grid
	var y:int = 0
	for t in total_grid:
		var x:int = 0
		for s in t:
			if !parsed_grid[y][x]:
				parsed_fences = []
				
				var plot_info:Array = calc_region(Vector2i(x,y))
				
				var valid_array:Array = []
				for f in parsed_fences:
					valid_array.append(true)
				var count:int = 0
				var sides:int = 0
				for f in parsed_fences:
					if valid_array[count]:
						#we found a unique side
						valid_array[count] = false
						sides+=1
						var move_vec:Vector2i
						match f.z:
							0:
								move_vec = Vector2i(-1,0)
							90:
								move_vec = Vector2i(0,1)
							180:
								move_vec = Vector2i(1,0)
							270:
								move_vec = Vector2i(0,-1)
						var current_x:int = f.x
						var current_y:int = f.y
						var plus_dir:bool = parsed_fences.has(Vector3i(current_x+move_vec.x,current_y+move_vec.y,f.z))
						var min_dir:bool = parsed_fences.has(Vector3i(current_x-move_vec.x,current_y-move_vec.y,f.z))
						while plus_dir:
							
							valid_array[parsed_fences.find(Vector3i(current_x+move_vec.x,current_y+move_vec.y,f.z))] = false
							current_x += move_vec.x
							current_y += move_vec.y
							plus_dir = parsed_fences.has(Vector3i(current_x+move_vec.x,current_y+move_vec.y,f.z))
						current_x = f.x
						current_y = f.y
						while min_dir:
							
							valid_array[parsed_fences.find(Vector3i(current_x-move_vec.x,current_y-move_vec.y,f.z))] = false
							current_x -= move_vec.x
							current_y -= move_vec.y
							min_dir = parsed_fences.has(Vector3i(current_x-move_vec.x,current_y-move_vec.y,f.z))
						
						
					count+=1
				
				regions[Vector2i(x,y)] = [total_grid[y][x],plot_info[0],plot_info[1],sides]
			x+=1
		y+=1
	
	
	var total:int = 0
	for h in regions.keys():
		#print(regions[h])
		#Part 1
		#total+=regions[h][1]*regions[h][2]
		#Part2
		total += regions[h][1] * regions[h][3]
	print("Total:"+str(total))
	
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")

#fences are parsed as Vector3 with x/y being the grid coords and z being the facing
func calc_region(input:Vector2i):
	parsed_grid[input.y][input.x] = true
	var region:Array = [1,0]
	var addition:Array = []
	#N
	if in_bounds(Vector2i(input.x,input.y-1)) and total_grid[input.y][input.x]== total_grid[input.y-1][input.x]:
		if !parsed_grid[input.y-1][input.x]:
			addition = calc_region(Vector2i(input.x,input.y-1))
			region[0]+= addition[0]
			region[1]+= addition[1]
	else:
		parsed_fences.append(Vector3i(input.x,input.y,0))
		region[1]+=1
	#E
	if in_bounds(Vector2i(input.x+1,input.y)) and total_grid[input.y][input.x]== total_grid[input.y][input.x+1]:
		if !parsed_grid[input.y][input.x+1]:
			addition = calc_region(Vector2i(input.x+1,input.y))
			region[0]+= addition[0]
			region[1]+= addition[1]
	else:
		parsed_fences.append(Vector3i(input.x,input.y,90))
		region[1]+=1
	#S
	if in_bounds(Vector2i(input.x,input.y+1)) and total_grid[input.y][input.x]== total_grid[input.y+1][input.x] :
		if !parsed_grid[input.y+1][input.x]:
			addition = calc_region(Vector2i(input.x,input.y+1))
			region[0]+= addition[0]
			region[1]+= addition[1]
	else:
		parsed_fences.append(Vector3i(input.x,input.y,180))
		region[1]+=1
	#W
	if in_bounds(Vector2i(input.x-1,input.y)) and total_grid[input.y][input.x]== total_grid[input.y][input.x-1] :
		if !parsed_grid[input.y][input.x-1]:
			addition = calc_region(Vector2i(input.x-1,input.y))
			region[0]+= addition[0]
			region[1]+= addition[1]
	else:
		parsed_fences.append(Vector3i(input.x,input.y,270))
		region[1]+=1
	
	return region

func in_bounds(input:Vector2i):
	return (input.x>-1 and input.y >-1 and input.x<total_grid[0].size() and input.y < total_grid.size())
	
