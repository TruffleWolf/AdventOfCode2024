extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day13input.txt",FileAccess.READ)

var buttons_A:Array[Vector2i] = []
var buttons_B:Array[Vector2i] = []
var prizes:Array = []



func _ready():
	var start_time:int = Time.get_ticks_msec()
	
	var step:int = 0
	while !input_doc.eof_reached():
		
		var line = input_doc.get_line()
		
		match step%4:
			0:
				var splitsA = line.split(" ")
				buttons_A.append(Vector2i(int(splitsA[-2]),int(splitsA[-1])))
			1:
				var splitsB = line.split(" ")
				buttons_B.append(Vector2i(int(splitsB[-2]),int(splitsB[-1])))
			2:
				var splitsP = line.split(" ")
				prizes.append([int(splitsP[-2]),int(splitsP[-1])])
			3:
				pass
		step+=1
	
	
	
	#part1
	#part_1()
	#part2
	part_2()
	
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")

func part_2():
	var total:int = 0
	var pos:int = 0
	for p in prizes:
		prizes[pos][0] += 10000000000000
		prizes[pos][1] += 10000000000000
		
		var solution:int = find_best_solution(pos)
		print(solution)
		total+=solution
		
		pos+=1
		
	
	print("Total:"+str(total))
	


func find_best_solution(index:int):
	var solution:Array = [-1,-1,9223372036854775806]
	var target_A:Vector2i = buttons_A[index]
	var target_B:Vector2i = buttons_B[index]
	var target_prize:Array = prizes[index]
	
	#var a_loops:int = ceili(min(target_prize[0]/target_A.x,target_prize[1]/target_A.y))
	#var b_loops:int = ceili(min(target_prize[0]/target_B.x,target_prize[1]/target_B.y))
	#
	#print("INDEX:"+str(index)+" OF "+str(prizes.size())+" LOOPS:"+str(a_loops)+"|"+str(b_loops))
	#for x in a_loops+1:
		#for y in b_loops+1:
			#if (target_A.x*x)+(target_B.x*y)==target_prize[0] and (target_A.y*x)+(target_B.y*y)==target_prize[1]:
				#var cost:int = (x*3)+y
				#if cost<solution[2]:
					#solution = [x,y,cost]
			#elif (target_A.x*x)+(target_B.x*y)>target_prize[0] or (target_A.y*x)+(target_B.y*y)>target_prize[1]:
				#break
			#
	
	solution[1] = ((target_A.x*target_prize[1])-(target_A.y*target_prize[0]))/((target_A.x*target_B.y)-(target_A.y*target_B.x))
	var y_float = ((target_A.x*target_prize[1])-(target_A.y*target_prize[0]))%((target_A.x*target_B.y)-(target_A.y*target_B.x))
	solution[0] = (target_prize[0]-(target_B.x*solution[1]))/target_A.x
	var x_float = (target_prize[0]-(target_B.x*solution[1]))%target_A.x
	if y_float==0 and x_float==0:
		return (solution[0]*3)+solution[1]
	return 0
	


func part_1():
	var total:int = 0
	var count:int = 0
	for p in prizes:
		var solution:int = find_best_solution(count)
		print(solution)
		total+=solution
		count +=1
	
	print("Total:"+str(total))

#a very slow brute force
#func find_possible_solutions_1(index:int):
	#var solutions:Array[Vector2i] = []
	#var target_A:Vector2i = buttons_A[index]
	#var target_B:Vector2i = buttons_B[index]
	#var target_prize:Array = prizes[index]
	#
	#var a_loops:int = ceili(min(target_prize[0]/target_A.x,target_prize[1]/target_A.y,101))
	#var b_loops:int = ceili(min(target_prize[0]/target_B.x,target_prize[1]/target_B.y,101))
	#
	#for x in a_loops+1:
		#for y in b_loops+1:
			#if (target_A.x*x)+(target_B.x*y)==target_prize[0] and (target_A.y*x)+(target_B.y*y)==target_prize[1]:
				#solutions.append(Vector2i(x,y))
			#elif (target_A.x*x)+(target_B.x*y)>target_prize[0] or (target_A.y*x)+(target_B.y*y)>target_prize[1]:
				#break
	#
	#return solutions
#
#func find_cheapest_solution(input:Array[Vector2i]):
	#var cheapest_index:int = 0
	#var cheapest_score:int = (input[0].x*3)+input[0].y
	#
	#var count:int = 0
	#for i in input:
		#var new_score = (i.x*3)+i.y
		#if new_score<cheapest_score:
			#cheapest_index = count
			#cheapest_score= new_score
		#
		#count += 1
	#
	#print("Cheapest:"+str(input[cheapest_index]))
	#return cheapest_score
	#
	
	
	
	
	
