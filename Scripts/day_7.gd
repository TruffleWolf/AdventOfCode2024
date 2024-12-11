extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day7input.txt",FileAccess.READ)

var results:Array = []
var equations:Array = []

func _ready() -> void:
	
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split(":")
		if row.size()>1:
			results.append(int(row[0]))
			var eq_str = row[1].split(" ",false)
			var new_array:Array = []
			for e in eq_str:
				new_array.append(int(e))
			
			equations.append(new_array)
	
	
	var valid_results = []
	var count = 0
	for r in results:
		
		#part 1
		#if is_valid(r,equations[count]):
			#valid_results.append(r)
		#part 2
		if is_conc_valid(r,equations[count]):
			valid_results.append(r)
		count+=1
	
	
	var total:int = 0
	for v in valid_results:
		total+=v
	print("Total:"+str(total))

func is_conc_valid(result:int,numbers:Array):
	if numbers.size()==1:
		return result == numbers[0]
	var answer_array = [numbers[0]]
	
	var stage:int = 0
	while stage != numbers.size()-1:
		var new_array = []
		for a in answer_array:
			new_array.append(a*numbers[stage+1])
			new_array.append(a+numbers[stage+1])
			var concatenation = str(a)+str(numbers[stage+1])
			new_array.append(int(concatenation))
		answer_array = new_array
		stage +=1
	
	return answer_array.has(result)

func is_valid(result:int,numbers:Array):
	if numbers.size()==1:
		return result == numbers[0]
	var answer_array = [numbers[0]]
	
	var stage:int = 0
	while stage != numbers.size()-1:
		var new_array = []
		for a in answer_array:
			new_array.append(a*numbers[stage+1])
			new_array.append(a+numbers[stage+1])
		answer_array = new_array
		stage +=1
	
	return answer_array.has(result)
