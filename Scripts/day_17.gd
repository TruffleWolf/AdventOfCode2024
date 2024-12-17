extends Node
# I'm Sorry.

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day17input.txt",FileAccess.READ)

var reg_A:int = 0
var reg_B:int = 0
var reg_C:int = 0
# X=opcode,Y=operand
var program:Array[int]=[]

var pointer:int = 0

var output_list:Array[int]
var instructions:Array[String]=["adv","bxl","bst","jnz","bxc","out","bdv","cdv"]
var combo_list:Array[String]=["combo_0","combo_1","combo_2","combo_3","combo_4","combo_5","combo_6","combo_7"]
var new_program:Array[int] = []
var correct_reg:int = 0


func _ready():
	#parse the document
	reg_A = int(input_doc.get_line().split(" ")[-1])
	reg_B = int(input_doc.get_line().split(" ")[-1])
	reg_C = int(input_doc.get_line().split(" ")[-1])
	input_doc.get_line()
	var row = input_doc.get_line().split(",")
	for i in row:
		
		program.append(int(i))
	
	#reg_A = 202366627359274
	#var time = Time.get_ticks_msec()
	#part one
	#part_one()
	#part two
	part_two()
	#print("TIME:"+str(Time.get_ticks_msec()-time))


func part_two():
	#the actual recursive solution after forsaking voodoo
	var candidates:Array[int]= [0]
	var step = 1
	for p in program.size():
		var new_candidates:Array[int]=[]
		for c in candidates:
			for i in 8:
				reg_A = (c<<3)+i
				var axor:int = (reg_A%8)^1
				reg_B = (axor^(reg_A/(2**axor)))^4
				if reg_B%8 == program[-step]:
					new_candidates.append(reg_A)
				
		candidates = new_candidates
		step+=1
		
	candidates.sort()
	print(candidates)
	
	
	#this code is voodoo that was manually adjusted to find various parameters
	# i found 10794 from messing with the big if on line 65. I suspect it is the seed my entry was given
	# Same process with the range 34446244570794 to 285522348310794 , the number must be between 2^45 and 2^49
	#correct_reg =10794+35184372088832
	#var increment:int = 34359738368
	#
	#while new_program != program and correct_reg<2855223483107942:
		#
		#output_list = []
		#reg_A = correct_reg
		#pointer = 0
		#while pointer < program.size()-1:
			#call(instructions[program[pointer]],program[pointer+1])
			#pointer+=2
		#
		#use this code first to find how long between candidate blocks to check
		#if output_list.size()==program.size() and output_list[0]==program[0]and output_list[1]==program[1]and output_list[2]==program[2]and output_list[3]==program[3]and output_list[4]==program[4]and output_list[5]==program[5]and output_list[6]==program[6]and output_list[7]==program[7]and output_list[8]==program[8]and output_list[9]==program[9]and output_list[10]==program[10]and output_list[11]==program[11]:
			#print("FOUND"+str(correct_reg))
			#for i in 8:
				#output_list = []
				#reg_A = correct_reg
				#pointer = 0
				#while pointer < program.size()-1:
					#call(instructions[program[pointer]],program[pointer+1])
					#pointer+=2
				#if output_list == program:
					#correct_reg+=i
					#break
		#
		#if correct_reg%10794==0:
			#print(correct_reg)
		#correct_reg+=increment
		#
		#new_program = output_list
	#
	#if new_program == program:
		#print("value"+str(correct_reg-increment))
	#else:
		#print("not found")
		
	
	

func the_program(point:int):
	var step = -1
	var candidate_branches:Array[int] = [0]
	for i in 16:
		reg_A = i
		#while reg_A!=0:
		var axor:int = (reg_A%8)^1
		reg_B = (axor^(reg_A/(2**axor)))^4
		if reg_B%8 == program[-step-point]:
			return i
			#output_list.append(reg_B%8)
			#reg_A = int(reg_A/(2**3))
			
	

func part_one():
	while pointer < program.size()-1:
		call(instructions[program[pointer]],program[pointer+1])
		pointer+=2
	
	#read the output
	var total_output:String = ""
	for o in output_list:
		total_output = total_output+str(o)+","
	
	
	print("Output:"+total_output.left(-1))

func combo_0():
	return 0
func combo_1():
	return 1
func combo_2():
	return 2
func combo_3():
	return 3
func combo_4():
	return reg_A
func combo_5():
	return reg_B
func combo_6():
	return reg_C
func combo_7():
	print("INVALID COMBO 7 RECIEVED")
	pointer = 999999999999

func get_combo(input:int):
	
	match input:
		0,1,2,3:
			return input
		4:
			return reg_A
		5:
			return reg_B
		6:
			return reg_C
		7:
			print("INVALID COMBO 7 RECIEVED")
			pointer = 999999999999

func adv(input:int):
	print("ADV:"+str(input))
	reg_A = reg_A/(2**call(combo_list[input]))
	#var output:int = reg_A/(2**get_combo(input))
	#print("adv:"+str(input),"->"+str(output))
	#reg_A = output

func bxl(input:int):
	print("bxl:"+str(input))
	reg_B = reg_B^input
	#var output:int = reg_B^input
	#print("blx:"+str(input),"->"+str(output))
	#reg_B = output

func bst(input:int):
	print("bst:"+str(input))
	reg_B = call(combo_list[input])%8
	#var output:int = get_combo(input)%8
	#print("bst:"+str(input),"->"+str(output))
	#reg_B = output

func jnz(input:int):
	print("jzn:"+str(input))
	if reg_A != 0:
		pointer = input - 2
		#var output:int = input
		#print("jnz:"+str(input),"->"+str(output))
		#pointer = output -2

func bxc(input:int):
	print("bxc:"+str(input))
	reg_B = reg_B ^ reg_C
	#var output:int = reg_B ^ reg_C
	#print("bxc:"+str(input),"->"+str(output))
	#reg_B = output

func out(input:int):
	print("out:"+str(input))
	output_list.append(call(combo_list[input])%8)
	#var output:int = get_combo(input)%8
	#print("out:"+str(input),"->"+str(output))
	#output_list.append(output)

func bdv(input:int):
	print("BDV:"+str(input))
	reg_B = reg_A/(2**call(combo_list[input]))
	#var output:int = reg_A/(2**get_combo(input))
	#print("bdv:"+str(input),"->"+str(output))
	#reg_B = output

func cdv(input:int):
	print("CDV:"+str(input))
	reg_C = reg_A/(2**call(combo_list[input]))
	#var output:int = reg_A/(2**get_combo(input))
	#print("cdv:"+str(input),"->"+str(output))
	#reg_C = output
