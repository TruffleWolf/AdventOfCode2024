extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day24input.txt",FileAccess.READ)

var values:Dictionary
var gates:Dictionary
var x_inputs:Dictionary
var y_inputs:Dictionary
var finals:Dictionary

func _ready() -> void:
	var bool_mode:bool = true
	while !input_doc.eof_reached():
		var row:String = input_doc.get_line()
		
		if row.length() ==0:
			bool_mode = !bool_mode
		elif bool_mode:
			values[row.left(3)]= int(row.right(1))
		else:
			gates[row.right(3)]= row.left(11).split(" ",false)
	
	for x in values.keys():
		if x.left(1)=="x":
			x_inputs[x]=values[x]
		else:
			y_inputs[x]=values[x]
	
	
	for g in gates.keys():
		if g.left(1)=="z":
			finals[g]=-1
	
	
	#part_one()
	part_two()

func part_two():
	#part two is less of a solution and more various tools to help me parse the gates
	#var keys = gates.keys()
	#keys.sort()
	#for k in keys:
		#print(gates[k][0]+" -> "+gates[k][0]+gates[k][1]+gates[k][2])
		#print(gates[k][2]+" -> "+gates[k][0]+gates[k][1]+gates[k][2])
	
	var wires = ["z09","hnd","z16","tdv","bks","z23","tjp","nrn"]
	#swap z09 and hnd
	var z9 = gates["z09"].duplicate()
	var hnd = gates["hnd"].duplicate()
	gates["z09"] = hnd
	gates["hnd"] = z9
	
	#swap z16 and tdv
	var tdv = gates["tdv"].duplicate()
	var z16 = gates["z16"].duplicate()
	gates["tdv"] = z16
	gates["z16"] = tdv
	
	#swap bks and z23
	var z23 = gates["z23"].duplicate()
	var bks = gates["bks"].duplicate()
	gates["z23"] = bks
	gates["bks"] = z23
	
	#swap tjp and nrn
	var nrn = gates["nrn"].duplicate()
	var tjp = gates["tjp"].duplicate()
	gates["nrn"] = tjp
	gates["tjp"] = nrn
	
	
	
	var x_numb:int = 0
	var y_numb:int = 0
	var expected_z:int = 0
	var final_z:int = part_one()
	
	var v_keys = values.keys()
	v_keys.sort()
	for v in v_keys:
		print(v+":"+str(values[v]))
		
	var total:int = 0
	var count:int =0
	var k_list = x_inputs.keys()
	k_list.sort()
	for k in k_list:
		total+=x_inputs[k]*(2**count)
		count+=1
	x_numb = total
	
	total = 0
	count = 0
	k_list = y_inputs.keys()
	k_list.sort()
	for k in k_list:
		total+=y_inputs[k]*(2**count)
		count+=1
	y_numb = total
	expected_z = x_numb+y_numb
	
	print(x_numb)
	print(y_numb)
	var expected_str:String = String.num_int64(expected_z,2)
	var final_str:String = String.num_int64(final_z,2)
	print("expected")
	print(String.num_int64(expected_z,2))
	print(String.num_int64(final_z,2))
	count = 1
	for b in expected_str:
		if expected_str[-count] != final_str[-count]:
			print("z"+str(count-1))
			print("expected:"+str(expected_str[-count]))
			break
		count+=1
	
	wires.sort()
	print(wires)

func part_one():
	while !is_z_complete():
		for g in gates.keys():
			if values.keys().has(gates[g][0]) and values.keys().has(gates[g][2]):
				
				match gates[g][1]:
					"OR":
						values[g] = int(values[gates[g][0]] + values[gates[g][2]]>0)
					"XOR":
						values[g] = int(values[gates[g][0]]+values[gates[g][2]]==1)
					"AND":
						values[g] = int(values[gates[g][0]] + values[gates[g][2]]==2)
				if finals.keys().has(g):
					finals[g] = values[g]
				gates.erase(g)
		#print(values)
	
	
	var total:int = 0
	var count:int =0
	var k_list = finals.keys()
	k_list.sort()
	for k in k_list:
		total+=finals[k]*(2**count)
		count+=1
	
	print("total:"+str(total))
	return total

func is_z_complete():
	var complete:bool = true
	for k in finals.keys():
		complete=complete and finals[k]!=-1
	#print(finals)
	return complete
