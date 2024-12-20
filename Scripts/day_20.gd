extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day20input.txt",FileAccess.READ)

var map:Array = []
var start_pos:Vector2i 
var end_pos:Vector2i

var directions:Array[Vector2i]=[Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0)]

#var map_scores:Array[Array]
var default_time:int = 0
var cheat_scores:Array[int]
var potential_cheats:Array[Vector2i]
var potential_positions:Array[Array]
var default_path:Array
var default_score:int = 0
var target_score:int = 0

func _ready() -> void:
	#parse the document
	var y_pos:int = 0
	while !input_doc.eof_reached():
		
		var row = input_doc.get_line().split("")
		var x_pos:int = 0
		#var new_score:Array
		for r in row:
			if r == "S":
				start_pos = Vector2i(x_pos,y_pos)
			elif r == "E":
				end_pos = Vector2i(x_pos,y_pos)
			#new_score.append(9999)
			x_pos +=1
		#map_scores.append(new_score)
		map.append(row)
		y_pos += 1
	
	map.resize(map.size()-1)
	
	
	
	solve_maze()
	
	#part one
	#part_one()
	#part two
	part_two()
	
	#score calculation is identical in both parts
	var total:int = 0
	
	#print(cheat_scores)
	for s in cheat_scores:
		if s >99:
			total+=1
	
	print("Total:"+str(total))

func part_two():
	default_path.pop_front()
	print(default_path.size())
	#1,3
	#1,13
	var count:int = 0
	for start in default_path:
		var jump_points:Array[int]
		var e_count:int = 0
		for end in default_path:
			var distance:int = abs(start.x-end.x)+abs(start.y-end.y)
			if distance<21 and e_count>count:
				target_score = e_count - count
				#if count == 0 and e_count>84:
					#print("target:"+str(target_score))
					#print(target_score-(abs(start.x-end.x)+abs(start.y-end.y)))
				jump_points.append(target_score-distance)
			e_count+=1
		print("pos:"+str(count))
		cheat_scores.append_array(jump_points)
		count+=1
	


func part_one():
	
	var y_pos = 0
	for m in map:
		var x_pos = 0
		for l in m:
			if l == "#":
				
				
				var cheat_points:Array[Vector2i]
				for d in directions:
					if is_in_bounds(Vector2i(x_pos+d.x,y_pos+d.y)) and (map[y_pos+d.y][x_pos+d.x]=="." or map[y_pos+d.y][x_pos+d.x]=="E" or map[y_pos+d.y][x_pos+d.x]== "S"):
						cheat_points.append(Vector2i(x_pos+d.x,y_pos+d.y))
				
				if cheat_points.size() == 2:
					potential_cheats.append(Vector2i(x_pos,y_pos))
					potential_positions.append(cheat_points)
			x_pos+=1
		y_pos+=1
	
	var count:int = 0
	for p in potential_cheats:
		
		target_score = abs(default_path.find(potential_positions[count][0])-default_path.find(potential_positions[count][1]))
		#print("normal score"+str(target_score))
		
		cheat_scores.append(target_score-2)
		
		count+=1
	
	
	
	


func solve_maze():
	var current_step:int = 0
	var solver_positions:Array[Vector2i]=[start_pos]
	var parsed_positions:Array[Array]=[[start_pos]]
	var branch_sizes:Array[int] = [0]
	
	var total_branches:int = 1
	var solved_steps:int = 0
	#var path_limit:int = 1000
	var current_length:int = 0
	
	while solver_positions.size()>current_step:
		
		var potential_steps:Array[Vector2i] = []
			
		for d in directions:
			#pray for me brother as I go to read this giant if
			if is_in_bounds(Vector2i(solver_positions[current_step].x+d.x,solver_positions[current_step].y+d.y)) and map[solver_positions[current_step].y+d.y][solver_positions[current_step].x+d.x] == "." and !parsed_positions[current_step].has(solver_positions[current_step]+d):
				potential_steps.append(d)
				
				
		for d in directions:
			if Vector2i(solver_positions[current_step].x+d.x,solver_positions[current_step].y+d.y) == end_pos and (default_score==0 or parsed_positions[current_step].size()<target_score):
				if default_score == 0:
					parsed_positions[current_step].append(solver_positions[current_step])
					parsed_positions[current_step].append(end_pos)
					default_path = parsed_positions[current_step].duplicate()
					default_score = parsed_positions[current_step].size()
					print("Default ok")
					return
				else:
					print("FOUND PATH:"+str(parsed_positions[current_step].size()))
					cheat_scores.append(parsed_positions[current_step].size())
					return
				
		
		
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
			
			#map_scores[solver_positions[current_step].y][solver_positions[current_step].x] = parsed_positions[current_step].size()
			#print("moving from:"+str(old_pos)+" to:"+str(solver_positions[current_step]))
			#print("score from:"+str(old_score)+" to:"+str(solver_scores[current_step]))
			
		else:
			#if solved_steps%10000==0:
				#print("DeadBranch:"+str(solved_steps)+" of:"+str(total_branches))
				#if solved_steps%100000==0:
					#for m in map_scores:
						#print(m)
			if current_step<solver_positions.size():
				parsed_positions.pop_at(current_step)
				branch_sizes.pop_at(current_step)
				solver_positions.pop_at(current_step)
			solved_steps+=1

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
				
				parsed_positions.append(parsed_positions[current_step].duplicate())
				branch_sizes.append(parsed_positions[current_step].size())
				#map_scores[old_pos.y+p.y][old_pos.x+p.x] = parsed_positions[current_step].size()
	print("path not found")
	cheat_scores.append(0)

#func clear_map_scores():
	#for m in map_scores:
		#for l in m:
			#l = 9999

func is_in_bounds(input:Vector2i):
	return (input.x>-1 and input.x<map[0].size() and input.y>-1 and input.y<map.size())
