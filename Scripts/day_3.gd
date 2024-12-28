extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day3input.txt",FileAccess.READ)
@onready var total_string:String = input_doc.get_as_text()
var mult_list:Array



func _ready() -> void:
	var start_time:int = Time.get_ticks_msec()
	
	#part 1
	#mult_list = compile_all_multi(total_string)
	#part 2
	mult_list = compile_enabled_multi(total_string)
	
	var total:int = 0
	for m in mult_list:
		
		total += convert_mult(m)
	
	
	print(total)
	
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")


func compile_enabled_multi(input_str:String):
	
	var new_array:Array = []
	
	var enabled_strings = input_str.split("do()")
	var filtered_strings = []
	
	
	for e in enabled_strings:
		
		filtered_strings.append(e.get_slice("don't()",0))
	
	
	
	for f in filtered_strings:
		if new_array.size() == 70:
			print(f)
		new_array = new_array+compile_all_multi(f)
		print(new_array.size())
	
	var test_array = [enabled_strings.size(),new_array.size()]
	print(test_array)
	
	
	return new_array


func compile_all_multi(input_str:String):
	var new_array:Array
	
	var parse_string = input_str
	
	while parse_string.contains("mul("):
		var start_location:int = parse_string.find("mul(")
		var clamped_str = parse_string
		if start_location>0:
			clamped_str = parse_string.right(-start_location)
		
		var end_location = clamped_str.find(")")
		if end_location == -1:
			break
		else:
			clamped_str = clamped_str.left(end_location+1)
			
			
			if clamped_str.contains(","):
				var halves:Array = clamped_str.split(",")
				if halves.size() == 2:
					var a_str = halves[0].right(-4)
					var b_str = halves[1].left(-1)
					if a_str.is_valid_int() and a_str.length()<4 and b_str.is_valid_int() and b_str.length()<4:
						
						new_array.append(clamped_str)
						
			parse_string = parse_string.right(-(start_location+1))
	
	return new_array
	



#performs the math given valid "mul(X,Y)" strings
func convert_mult(input:String):
	var stripped_string = input.right(-4).left(-1)
	
	var numbers:Array
	for a in stripped_string.split(","):
		numbers.append(int(a))
	return numbers[0]*numbers[1]
