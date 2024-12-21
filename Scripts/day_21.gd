extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day21input.txt",FileAccess.READ)

var codes:Array[Array]
var code_values:Array[int]
var code_presses:Array[int]

var directional_robots:int = 0
var directional_list:Array[Array]

#the min number of moves to input one position to another
#index 0 is the first level directional robot's position
#position data 0 is A on directionals,1234 are left down right up,10 is A on numeric
var key1_robot:Array[Array] = [[1,4,3,2,2],[4,1,2,3,3],[3,2,1,2,2],[2,3,2,1,3],[2,3,2,3,1]]

var pad_robot:Array[Array] 



func _ready() -> void:
	
	while !input_doc.eof_reached():
		
		var row = input_doc.get_line()
		if row.length()>0:
			code_values.append(int(row))
			var split_row = row.split("")
			codes.append([int(split_row[0]),int(split_row[1]),int(split_row[2])])
	
	#part_one()
	
	part_two()
	
	var start_number = 10
	var count:int = 0
	for c in codes:
		var end_number = c[0]
		var presses:int = pad_robot[10][c[0]]+pad_robot[c[0]][c[1]]+pad_robot[c[1]][c[2]]+pad_robot[c[2]][10]
		code_presses.append(presses)
		count+=1
	
	
	var total:int = 0
	count = 0
	for c in code_values:
		total += c * code_presses[count]
		print(str(c*code_presses[count])+" from "+str(c)+"*"+str( code_presses[count]))
		count+=1
	
	print("Total:"+str(total))

func part_two():
	directional_robots = 25
	
	directional_list.append(key1_robot)
	
	for i in directional_robots-1:
		var new_robot:Array = create_dir_robot(directional_list[i])
		directional_list.append(new_robot)
	
	
	#manually calculated optimal pad robot movements
	pad_robot = [
		[directional_list[-1][0][0],directional_list[-1][0][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][0]]]
	


func create_dir_robot(robot_inputs:Array):
	
	var row_0:Array[int] = [1,
		robot_inputs[0][2]+robot_inputs[2][1]+robot_inputs[1][1]+robot_inputs[1][0],
		mini(robot_inputs[0][2]+robot_inputs[2][1]+robot_inputs[1][0],robot_inputs[0][1]+robot_inputs[1][2]+robot_inputs[2][0]),
		robot_inputs[0][2]+robot_inputs[2][0],
		robot_inputs[0][1]+robot_inputs[1][0]
		]
	var row_1:Array[int] = [robot_inputs[0][3]+robot_inputs[3][3]+robot_inputs[3][4]+robot_inputs[4][0],
		1,
		robot_inputs[0][3]+robot_inputs[3][0],
		robot_inputs[0][3]+robot_inputs[3][3]+robot_inputs[3][0],
		robot_inputs[0][3]+robot_inputs[3][4]+robot_inputs[4][0]
		]
	var row_2:Array[int] = [mini(robot_inputs[0][4]+robot_inputs[4][3]+robot_inputs[3][0],robot_inputs[0][3]+robot_inputs[3][4]+robot_inputs[4][0]),
		robot_inputs[0][1]+robot_inputs[1][0],
		1,
		robot_inputs[0][3]+robot_inputs[3][0],
		robot_inputs[0][4]+robot_inputs[4][0]
		]
	var row_3:Array[int] = [robot_inputs[0][4]+robot_inputs[4][0],
		robot_inputs[0][1]+robot_inputs[1][1]+robot_inputs[1][0],
		robot_inputs[0][1]+robot_inputs[1][0],
		1,
		mini(robot_inputs[0][1]+robot_inputs[1][4]+robot_inputs[4][0],robot_inputs[0][4]+robot_inputs[4][1]+robot_inputs[1][0])
		]
	var row_4:Array[int] = [robot_inputs[0][3]+robot_inputs[3][0],
		robot_inputs[0][2]+robot_inputs[2][1]+robot_inputs[1][0],
		robot_inputs[0][2]+robot_inputs[2][0],
		mini(robot_inputs[0][2]+robot_inputs[2][3]+robot_inputs[3][0],robot_inputs[0][3]+robot_inputs[3][2]+robot_inputs[2][0]),
		1]
	
	return [row_0,row_1,row_2,row_3,row_4]


func part_one():
	
	directional_robots = 2
	
	directional_list.append(key1_robot)
	
	for i in directional_robots-1:
		var new_robot:Array[Array]
		#manually calculated optimal directional movements
		directional_list[i][0][1]+directional_list[i][1][2]+directional_list[i][2][0]
		new_robot.append([directional_list[i][0][0],directional_list[i][0][2]+directional_list[i][2][1]+directional_list[i][1][1]+directional_list[i][1][0],directional_list[i][0][1]+directional_list[i][1][2]+directional_list[i][2][0],directional_list[i][0][2]+directional_list[i][2][0],directional_list[i][0][1]+directional_list[i][1][0]])
		new_robot.append([directional_list[i][0][3]+directional_list[i][3][3]+directional_list[i][3][4]+directional_list[i][4][0],directional_list[i][1][1],directional_list[i][0][3]+directional_list[i][3][0],directional_list[i][0][3]+directional_list[i][3][3]+directional_list[i][3][0],directional_list[i][0][3]+directional_list[i][3][4]+directional_list[i][4][0]])
		new_robot.append([directional_list[i][0][3]+directional_list[i][3][4]+directional_list[i][4][0],directional_list[i][0][1]+directional_list[i][1][0],directional_list[i][2][2],directional_list[i][0][3]+directional_list[i][3][0],directional_list[i][0][4]+directional_list[i][4][0]])
		new_robot.append([directional_list[i][0][4]+directional_list[i][4][0],directional_list[i][0][1]+directional_list[i][1][1]+directional_list[i][1][0],directional_list[i][0][1]+directional_list[i][1][0],directional_list[i][3][3],directional_list[i][0][1]+directional_list[i][1][4]+directional_list[i][4][0]])
		new_robot.append([directional_list[i][0][3]+directional_list[i][3][0],directional_list[i][0][2]+directional_list[i][2][1]+directional_list[i][1][0],directional_list[i][0][2]+directional_list[i][2][0],directional_list[i][0][2]+directional_list[i][2][3]+directional_list[i][3][0],directional_list[i][4][4]])
		directional_list.append(new_robot)
	
	
	#manually calculated optimal pad robot movements
	pad_robot = [
		[directional_list[-1][0][0],directional_list[-1][0][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][0],directional_list[-1][0][3]+directional_list[-1][3][3]+directional_list[-1][3][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][3]+directional_list[-1][3][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][3]+directional_list[-1][3][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][3]+directional_list[-1][3][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][2]+directional_list[-1][2][0],directional_list[-1][0][2]+directional_list[-1][2][0],directional_list[-1][0][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][0],directional_list[-1][0][2]+directional_list[-1][2][2]+directional_list[-1][2][2]+directional_list[-1][2][0]],
		[directional_list[-1][0][1]+directional_list[-1][1][0],directional_list[-1][0][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][1]+directional_list[-1][1][1]+directional_list[-1][1][0],directional_list[-1][0][1]+directional_list[-1][1][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][4]+directional_list[-1][4][4]+directional_list[-1][4][4]+directional_list[-1][4][0],directional_list[-1][0][0]]]
	
