extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day16input.txt",FileAccess.READ)

var maze:Array = []
var start_pos:Vector2i 
var end_pos:Vector2i
var best_score:int = 9999999
var relevant_squares:Array[Vector2i]
var relevant_scores:Array[int]

var path_scores:Array[int]
var path_counts:Array[Array]

var directions:Array[Vector2i]=[Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0)]

func _ready() -> void:
	#parse the document
	var y_pos:int = 0
	while !input_doc.eof_reached():
		
		var row = input_doc.get_line().split("")
		var x_pos:int = 0
		
		for r in row:
			if r == "S":
				start_pos = Vector2i(x_pos,y_pos)
			elif r == "E":
				end_pos = Vector2i(x_pos,y_pos)
			
			x_pos +=1
		maze.append(row)
		y_pos += 1
	
	maze.resize(maze.size()-1)
	
	cleanup()
	solve_maze()
	
	#part 1
	#print("Score:"+str(best_score))
	#part2
	part_two()


func part_two():
	var tile_list:Array[Vector2i]
	
	var count:int = 0
	var total_paths:int = 0
	for p in path_counts:
		if path_scores[count]==best_score:
			total_paths +=1
			for t in p:
				if !tile_list.has(t):
					tile_list.append(t)
		
		count +=1
	#print(total_paths)
	#var y:int = 0
	#for m in maze:
		#var x:int = 0
		#for l in m:
			#if tile_list.has(Vector2i(x,y)):
				#maze[y][x]="W"
			#x+=1
		#y+=1
	#
	#for m in maze:
		#print(m)
	
	print("Tile Count:"+str(tile_list.size()+1))

#next time just copy someone else's pathfinding
func solve_maze():
	var current_step:int = 0
	var solver_positions:Array[Vector2i]=[start_pos]
	var parsed_positions:Array[Array]=[[start_pos]]
	var solver_scores:Array[int]=[0]
	var solver_angles:Array[Vector2i]=[Vector2i(1,0)]
	var total_branches:int = 1
	
	
	
	while current_step<total_branches:
		
		if solver_scores[current_step]>best_score:
			print("ScoredBranch:"+str(current_step)+" of "+str(total_branches))
			current_step+=1
		else:
			var potential_steps:Array[Vector2i] = []
			
			#paths only exist if its an empty space and this branch hasn't seen it and another branch hasn't gone there with a better score
			#if maze[solver_positions[current_step].y-1][solver_positions[current_step].x] == "." and !parsed_positions[current_step].has(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y-1)) and relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y-1))]>=get_best_exit_score(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y-1),Vector2i(0,-1)):
				#potential_steps.append(Vector2i(0,-1))
				#relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y-1))] = get_best_exit_score(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y-1),Vector2i(0,-1))
			#if maze[solver_positions[current_step].y][solver_positions[current_step].x+1] == "." and !parsed_positions[current_step].has(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y)) and relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y))]>=get_best_exit_score(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y),Vector2i(0,1)):
				#potential_steps.append(Vector2i(1,0))
				#relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y))] = get_best_exit_score(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y),Vector2i(1,0))
			#if maze[solver_positions[current_step].y+1][solver_positions[current_step].x] == "." and !parsed_positions[current_step].has(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y+1)) and relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y+1))]>solver_scores[current_step]:
				#potential_steps.append(Vector2i(0,1))
				#relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x,solver_positions[current_step].y+1))] = get_best_exit_score(Vector2i(solver_positions[current_step].x+1,solver_positions[current_step].y),Vector2i(0,1))
			#if maze[solver_positions[current_step].y][solver_positions[current_step].x-1] == "." and !parsed_positions[current_step].has(Vector2i(solver_positions[current_step].x-1,solver_positions[current_step].y)) and relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x-1,solver_positions[current_step].y))]>solver_scores[current_step]:
				#potential_steps.append(Vector2i(-1,0))
				#relevant_scores[relevant_squares.find(Vector2i(solver_positions[current_step].x-1,solver_positions[current_step].y))] = get_best_exit_score(Vector2i(solver_positions[current_step].x-1,solver_positions[current_step].y),Vector2i(-1,0))
			
			for d in directions:
				if maze[solver_positions[current_step].y+d.y][solver_positions[current_step].x+d.x] == "." and !parsed_positions[current_step].has(solver_positions[current_step]+d) and relevant_scores[relevant_squares.find(solver_positions[current_step]+d)]>=get_best_exit_score(solver_positions[current_step]+d,solver_angles[current_step],d,solver_scores[current_step]):
					potential_steps.append(d)
					
					relevant_scores[relevant_squares.find(solver_positions[current_step]+d)] = get_best_exit_score(solver_positions[current_step]+d,solver_angles[current_step],d,solver_scores[current_step])
					
			
			if maze[solver_positions[current_step].y-1][solver_positions[current_step].x] == "E":
				potential_steps = []
				solver_scores[current_step] += calc_turn_cost(solver_angles[current_step],Vector2i(0,-1))+1
				print("---"+str(solver_scores[current_step])+" against "+str(best_score))
				best_score = mini(solver_scores[current_step],best_score)
				
				if solver_scores[current_step] == best_score:
					parsed_positions[current_step].append(solver_positions[current_step])
					path_counts.append(parsed_positions[current_step])
					path_scores.append(best_score)
				
			elif maze[solver_positions[current_step].y][solver_positions[current_step].x+1] == "E":
				potential_steps = []
				solver_scores[current_step] += calc_turn_cost(solver_angles[current_step],Vector2i(1,0))+1
				print("---"+str(solver_scores[current_step])+" against "+str(best_score))
				best_score = mini(solver_scores[current_step],best_score)
				
				if solver_scores[current_step] == best_score:
					parsed_positions[current_step].append(solver_positions[current_step])
					path_counts.append(parsed_positions[current_step])
					path_scores.append(best_score)
				
			elif maze[solver_positions[current_step].y+1][solver_positions[current_step].x] == "E":
				potential_steps = []
				solver_scores[current_step] += calc_turn_cost(solver_angles[current_step],Vector2i(0,1))+1
				print("---"+str(solver_scores[current_step])+" against "+str(best_score))
				best_score = mini(solver_scores[current_step],best_score)
				
				if solver_scores[current_step] == best_score:
					parsed_positions[current_step].append(solver_positions[current_step])
					path_counts.append(parsed_positions[current_step])
					path_scores.append(best_score)
				
			elif maze[solver_positions[current_step].y][solver_positions[current_step].x-1] == "E":
				potential_steps = []
				solver_scores[current_step] += calc_turn_cost(solver_angles[current_step],Vector2i(-1,0))+1
				print("---"+str(solver_scores[current_step])+" against "+str(best_score))
				best_score = mini(solver_scores[current_step],best_score)
				
				if solver_scores[current_step] == best_score:
					parsed_positions[current_step].append(solver_positions[current_step])
					path_counts.append(parsed_positions[current_step])
					path_scores.append(best_score)
				
			
			
			#progress the current_branch
			var old_pos:Vector2i
			var old_score:int = 0
			var old_angle:Vector2i
			if potential_steps.size()>0:
				var next_step:Vector2i = potential_steps.pop_back()
				old_score = solver_scores[current_step]
				solver_scores[current_step] = old_score +calc_turn_cost(solver_angles[current_step],next_step)+1
				#print("same angle:"+str(solver_angles[current_step]==next_step))
				old_angle = solver_angles[current_step]
				solver_angles[current_step]=next_step
				old_pos = solver_positions[current_step]
				parsed_positions[current_step].append(old_pos)
				solver_positions[current_step]= solver_positions[current_step]+next_step
				#print("moving from:"+str(old_pos)+" to:"+str(solver_positions[current_step]))
				#print("score from:"+str(old_score)+" to:"+str(solver_scores[current_step]))
				
			else:
				#print("DeadBranch:"+str(current_step))
				current_step+=1
			#add new branches
			if potential_steps.size()>0:
				for p in potential_steps:
					total_branches+=1
					solver_positions.append(old_pos+p)
					#print("Branch made at"+str(old_pos+p))
					parsed_positions.append(parsed_positions[current_step].duplicate())
					var next_score:int = old_score + calc_turn_cost(old_angle,p)+1
					solver_scores.append(next_score)
					solver_angles.append(p)
				


func get_best_exit_score(pos:Vector2i,old_dir,new_dir:Vector2i,base_score:int):
	var scores:int = 999999
	
		
	for d in directions:
		var new_pos = pos+d
		if maze[new_pos.y][new_pos.x]=="#":
			scores = mini(scores,999999)
		elif maze[new_pos.y][new_pos.x]==".":
			scores = mini(scores,calc_turn_cost(new_dir,d))
	scores+=calc_turn_cost(old_dir,new_dir)
	
	return base_score+scores+1

func calc_turn_cost(start:Vector2i,end:Vector2i):
	if start == end:
		return 0
	else:
		return 1000

func cleanup():
	#clean up dead ends
	var complex:bool = true
	var complex_steps:int = 0
	while complex:
		print("Cleanup step:"+str(complex_steps))
		complex = false
		relevant_squares = []
		relevant_scores = []
		var y:int = 0
		for m in maze:
			var x:int = 0
			for l in m:
				if l == ".":
					var checked_walls:Array[Vector2i] = []
					if maze[y+1][x] =="#":
						checked_walls.append(Vector2i(0,1))
					if maze[y-1][x] =="#":
						checked_walls.append(Vector2i(0,-1))
					if maze[y][x+1] =="#":
						checked_walls.append(Vector2i(1,0))
					if maze[y][x-1] =="#":
						checked_walls.append(Vector2i(-1,0))
					if checked_walls.size()>2:
						complex = true
						maze[y][x] = "#"
					else:
						relevant_squares.append(Vector2i(x,y))
						relevant_scores.append(99999999999)
				x+=1
			y+=1
		complex_steps +=1
	

#func is_in_bounds(x,y):
	#return (x>-1 and y>-1 and x<maze[0].size() and y < maze.size())
