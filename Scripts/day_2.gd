extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day2input.txt",FileAccess.READ)
var input_array:Array

var input_line:Array[int]

var start_time:int = 0
func _ready() -> void:
	start_time = Time.get_ticks_msec()
	while !input_doc.eof_reached():
		input_line = []
		var new_string:String = input_doc.get_line()
		var split_array:Array = new_string.split(" ")
		
		for a in split_array:
			input_line.append(int(a))
		
		
		input_array.append(input_line.duplicate())
		
	
	input_array.resize(input_array.size()-1)
	
	
	
	#safety_check_1()
	safety_check_2()


func array_check(input:Array):
	
	var safe:bool = true
		
	if input.size()<2:
		return false
	elif input[0]>input[1]:
		#decending
		for b in input.size()-1:
			if !input[b]>input[b+1] or abs(input[b]-input[b+1])>3:
				return false
				
	elif input[0]<input[1]:
		#acending
		for b in input.size()-1:
			if !input[b]<input[b+1]or abs(input[b]-input[b+1])>3:
				return false
				
	else:
		return false
	
	return safe

func safety_check_2():
	
	var safety:int = 0
	for a in input_array:
		var safe:bool = true
		
		if !array_check(a):
			var fixed_safty:bool = false
			for b in a.size():
				var new_input:Array = a.duplicate()
				new_input.pop_at(b)
				if array_check(new_input):
					fixed_safty = true
					break
			
			safe = fixed_safty
		
		safety += int(safe)
	
	print(safety)
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")



func safety_check_1():
	var safety:int = 0
	for a in input_array:
		
		safety+= int(array_check(a))
	
	print(safety)
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")
