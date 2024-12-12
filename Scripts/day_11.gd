extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day11input.txt",FileAccess.READ)

@onready var stone_list:Array[int] = []



func _ready() -> void:
	
	var input_array = input_doc.get_line().split(" ",false)
	
	for i in input_array:
		stone_list.append(int(i))
	
	
	#25 for part 1, 75 for part 2
	parse_stones(75)
	
	


#all duplicate stones behave identically
#so we only need to track each unique stone and the number of times it apprears

func parse_stones(time:int):
	
	var parse_time:int = Time.get_ticks_msec()
	var quant_list:Array[int]
	for a in stone_list:
		quant_list.append(1)
	for i in time:
		var new_list:Array[int]
		var new_quant:Array[int]
		var count:int = 0
		for s in stone_list:
			if s == 0:
				new_list.append(1)
				new_quant.append(quant_list[count])
			elif (int(log(s)/log(10))+1)%2==0:
				new_list.append(int(s/(10**int((int(log(s)/log(10))+1)/2))))
				new_quant.append(quant_list[count])
				new_quant.append(quant_list[count])
				new_list.append(s%(10**int((int(log(s)/log(10))+1)/2)))
					
			else:
				new_list.append(s*2024)
				new_quant.append(quant_list[count])
			count+=1
		count = 0
		#filter out duplicate stones
		var filtered_array:Array[int] = []
		var filtered_quant:Array[int] = []
		for n in new_list:
			if filtered_array.has(n):
				filtered_quant[filtered_array.find(n)]+=new_quant[count]
			else:
				filtered_array.append(n)
				filtered_quant.append(new_quant[count])
			count +=1
			
		
		print(str(i)+" in "+ str((Time.get_ticks_msec()-parse_time)))
		parse_time = Time.get_ticks_msec()
		quant_list = filtered_quant
		stone_list = filtered_array
	
	
	var total:int = 0
	for z in quant_list:
		total+=z
	print("Total:"+str(total))
