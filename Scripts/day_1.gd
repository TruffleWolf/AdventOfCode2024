extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day1input.txt",FileAccess.READ)
var test_string:String 
var left_array:Array = []
var right_array:Array = []
var start_time:int = 0
func _ready():
	#Read file and seperate left and right
	start_time = Time.get_ticks_msec()
	while !input_doc.eof_reached():
		test_string = input_doc.get_line()
		left_array.append(int(test_string.left(5)))
		right_array.append(int(test_string.right(5)))
	
	#Delete junk line
	left_array.resize(left_array.size()-1)
	right_array.resize(right_array.size()-1)
	
	
	#part 1
	#difference_find()
	#part 2
	find_sim_score()
	

func find_sim_score():
	var sim_score:int = 0
	for a in left_array:
		var count:int = 0
		for b in right_array:
			count += int(a==b)
		sim_score+=a*count
	print(sim_score)
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")


func difference_find():
	left_array.sort()
	right_array.sort()
	
	var count:int = 0
	var total:int = 0
	for a in left_array:
		total += abs(a-right_array[count])
		count +=1
		
	print(total)
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")
