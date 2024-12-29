extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day9input.txt",FileAccess.READ)
#file key = file ID, file data is vector2i x = position y = length
var file_sizes:Dictionary
#empty key = position, data = length
var empty_spaces:Dictionary
var number_array:Array[int]

func _ready():
	var start_time:int = Time.get_ticks_msec()
	
	parse_document()
	
	
	#part 1
	#sort_drive_1()
	#part 2
	sort_drive_2()
	
	print_checksum()
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")


func parse_document():
	var array_string = input_doc.get_line()
	var empty_mode:bool = false
	var count:int = 0
	for a in array_string:
		var current_number:int = int(a)
		if empty_mode:
			empty_spaces[number_array.size()]=current_number
			for i in current_number:
				number_array.append(-1)
		else:
			file_sizes[count]=Vector2i(number_array.size(),current_number)
			for i in current_number:
				number_array.append(count)
			count+=1
		#number_array.append(int(a))
		empty_mode = !empty_mode
	
	
func sort_drive_2():
	var file_ids:Array = file_sizes.keys()
	var count:int = -1
	for f in file_ids:
		var target_id:int =  file_ids[count]
		var target_size:int = file_sizes[target_id].y
		var target_pos:int = file_sizes[target_id].x
		var space_locations:Array = empty_spaces.keys()
		space_locations.sort()
		for e in space_locations:
			if empty_spaces[e] >= target_size and e<target_pos:
				#Found a valid spot
				for t in target_size:
					number_array[e+t]=target_id
					number_array[target_pos+t]=-1
				print(target_id)
					#print("popped:"+str(number_array.pop_at(target_pos)))
				
				empty_spaces[e+target_size] = empty_spaces[e]-target_size
				empty_spaces.erase(e)
				break
			
		
		count -= 1
	

func sort_drive_1():
	
	var pos:int = 0
	for n in number_array:
		if n == -1:
			
			var pop_number:int = -1
			while pop_number == -1:
				
				pop_number = number_array.pop_back()
			number_array[pos] = pop_number
		pos+=1
	
	#for c in count:
		#number_array.append(-1)
	

func print_checksum():
	var checksum:int = 0
	var count:int = 0
	
	for n in number_array:
		if n>-1:
			checksum+=n*count
		count+=1
	
	print("total: "+str(checksum))
	

#func print_checksum_2():
	#var checksum:int = 0
	#var count:int = 0
	#
	#for n in number_array:
		#if n>-1:
			#checksum+=n*count
		#count+=1
	#
	#print("total: "+str(checksum))
