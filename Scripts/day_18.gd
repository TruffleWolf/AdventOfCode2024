extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day18input.txt",FileAccess.READ)

var grid_scale:Vector2i = Vector2i(71,71)
var byte_count:int=1024

var map:Array[Array]
var byte_starts:Array[Vector2i]

var map_scores:Array[Array]
var found_paths:Array[Array] =[]

const NORTH:Vector2i = Vector2i(0,-1)
const SOUTH:Vector2i = Vector2i(0,1)
const EAST:Vector2i = Vector2i(1,0)
const WEST:Vector2i = Vector2i(-1,0)
var directions:Array[Vector2i] = [NORTH,WEST,EAST,SOUTH]

var unique_paths

func _ready():
	#parse the document
	while !input_doc.eof_reached():
		var row = input_doc.get_line().split(",")
		if row.size()>1:
			byte_starts.append(Vector2i(int(row[0]),int(row[1])))
		
	
	
	#create grid
	for y in grid_scale.y:
		var new_row:Array
		var new_score:Array
		for x in grid_scale.x:
			new_row.append(".")
			new_score.append(9999)
		map.append(new_row)
		map_scores.append(new_score)
	
	for i in byte_count:
		map[byte_starts[i].y][byte_starts[i].x] = "#"
		map_scores[byte_starts[i].y][byte_starts[i].x]= -1
	
	
	cleanup()
	
	for m in map:
		print(m)
	
	#part two
	var count:int = 0
	var last_path:Array = []
	for p in byte_starts:
		map = []
		map_scores = []
		if count > 1023:
			byte_count = count
			for y in grid_scale.y:
				var new_row:Array
				var new_score:Array
				for x in grid_scale.x:
					new_row.append(".")
					new_score.append(9999)
				map.append(new_row)
				map_scores.append(new_score)
			
			
			for i in byte_count:
				map[byte_starts[i].y][byte_starts[i].x] = "#"
				map_scores[byte_starts[i].y][byte_starts[i].x]= -1
			
			
			if !check_last_path(last_path) or last_path.size() == 0:
				solve_maze()
				
				if found_paths.size()==0:
					#for m in map:
						#print(m)
					print(byte_starts[count-1])
					break
				else:
					last_path = found_paths[0].duplicate()
					print("step:"+str(count))
			else:
				print("Last path OK:"+str(count))
			found_paths = []
		count+=1
	
	#part one
	#solve_maze()
	#var length:int = 999999999999
	#for f in found_paths:
		#length = mini(length,f.size())
	#
	#print("Best Score:"+str(length))
	
	print("code complete")


func check_last_path(input:Array):
	for i in input:
		if map[i.y][i.x]=="#":
			return false
	return true


func solve_maze():
	var current_step:int = 0
	var solver_positions:Array[Vector2i]=[Vector2i(0,0)]
	var parsed_positions:Array[Array]=[[Vector2i(0,0)]]
	var branch_sizes:Array[int] = [0]
	#var solver_scores:Array[int]=[0]
	#var solver_angles:Array[Vector2i]=[Vector2i(1,0)]
	var total_branches:int = 1
	var solved_steps:int = 0
	#var path_limit:int = 1000
	var current_length:int = 0
	
	while solver_positions.size()>current_step:
		
		#if parsed_positions[current_step].size()>path_limit:
			#print("ScoredBranch:"+str(solved_steps)+" of "+str(total_branches))
			#parsed_positions[current_step] = []
			#branch_sizes[current_step] = 0
			#solved_steps+=1
			#var new_pos:int = 0
			#var new_length:int = 0
			#var count:int = 0
			#for b in branch_sizes:
				#if new_length<b:
					#new_pos = count
					#new_length = b
				#
				#count+=1
			#current_step = new_pos
			#
		#else:
		var potential_steps:Array[Vector2i] = []
			
		for d in directions:
			#pray for me brother as I go to read this giant if
			if is_in_bounds(Vector2i(solver_positions[current_step].x+d.x,solver_positions[current_step].y+d.y)) and map[solver_positions[current_step].y+d.y][solver_positions[current_step].x+d.x] == "." and !parsed_positions[current_step].has(solver_positions[current_step]+d) and map_scores[solver_positions[current_step].y+d.y][solver_positions[current_step].x+d.x] > parsed_positions[current_step].size():
				potential_steps.append(d)
				
				
		for d in directions:
			if Vector2i(solver_positions[current_step].x+d.x,solver_positions[current_step].y+d.y) == Vector2i(grid_scale.x-1,grid_scale.y-1):
				found_paths.append(parsed_positions[current_step])
				print("FOUND PATH:"+str(parsed_positions[current_step].size()))
				potential_steps = []
				#comment this out for part one
				current_step = 999999999999
				break
		
		
		#progress the current_branch
		var old_pos:Vector2i
		if potential_steps.size()>0:
			var next_step:Vector2i = potential_steps.pop_back()
			#print("same angle:"+str(solver_angles[current_step]==next_step))
			old_pos = solver_positions[current_step]
			parsed_positions[current_step].append(old_pos)
			if solver_positions.has(solver_positions[current_step]+next_step):
				#print("poped")
				var old_step = solver_positions.find(solver_positions[current_step]+next_step)
				parsed_positions.pop_at(old_step)
				branch_sizes.pop_at(old_step)
				solver_positions.pop_at(old_step)
				total_branches-=1
				if old_step<current_step:
					#print("poped")
					current_step-=1
			solver_positions[current_step]= solver_positions[current_step]+next_step
			
			map_scores[solver_positions[current_step].y][solver_positions[current_step].x] = parsed_positions[current_step].size()
			#print("moving from:"+str(old_pos)+" to:"+str(solver_positions[current_step]))
			#print("score from:"+str(old_score)+" to:"+str(solver_scores[current_step]))
			
		else:
			if solved_steps%10000==0:
				print("DeadBranch:"+str(solved_steps)+" of:"+str(total_branches)+" found:"+str(found_paths.size()))
				#if solved_steps%100000==0:
					#for m in map_scores:
						#print(m)
			if current_step<solver_positions.size():
				parsed_positions.pop_at(current_step)
				branch_sizes.pop_at(current_step)
				solver_positions.pop_at(current_step)
			solved_steps+=1
			#var new_pos:int = 0
			#current_length = 0
			#var count:int = 0
			#for b in branch_sizes:
				#if current_length<b:
					#current_step = count
					#current_length = b
				#
				#count+=1
			#current_step+=1
		#add new branches
		if potential_steps.size()>0:
			for p in potential_steps:
				if solver_positions.has(solver_positions[current_step]+p):
					#print("poped")
					var old_step = solver_positions.find(solver_positions[current_step]+p)
					parsed_positions.pop_at(old_step)
					branch_sizes.pop_at(old_step)
					solver_positions.pop_at(old_step)
					total_branches-=1
					if old_step<current_step:
						#print("poped")
						current_step-=1
				total_branches+=1
				solver_positions.append(old_pos+p)
				#print("Branch made at"+str(old_pos+p))
				parsed_positions.append(parsed_positions[current_step].duplicate())
				branch_sizes.append(parsed_positions[current_step].size())
				map_scores[old_pos.y+p.y][old_pos.x+p.x] = parsed_positions[current_step].size()
			
		#if current_step == solver_positions.size():
			#print("RESET")



func cleanup():
	#clean up dead ends
	var complex:bool = true
	var complex_steps:int = 0
	while complex:
		print("Cleanup step:"+str(complex_steps))
		complex = false
		var y:int = 0
		for m in map:
			var x:int = 0
			for l in m:
				if l == "." and !(x==0 and y==0) and !(x==70 and y==70):
					var checked_walls:Array[Vector2i] = []
					if !is_in_bounds(Vector2i(x,y+1)) or map[y+1][x] =="#":
						checked_walls.append(Vector2i(0,1))
					if !is_in_bounds(Vector2i(x,y-1)) or map[y-1][x] =="#":
						checked_walls.append(Vector2i(0,-1))
					if !is_in_bounds(Vector2i(x+1,y)) or map[y][x+1] =="#":
						checked_walls.append(Vector2i(1,0))
					if !is_in_bounds(Vector2i(x-1,y)) or map[y][x-1] =="#":
						checked_walls.append(Vector2i(-1,0))
					if checked_walls.size()>2:
						complex = true
						map[y][x] = "#"
				x+=1
			y+=1
		complex_steps +=1
	


func is_in_bounds(input:Vector2i):
	return (input.x>-1 and input.x<grid_scale.x and input.y>-1 and input.y<grid_scale.y)
	
	
