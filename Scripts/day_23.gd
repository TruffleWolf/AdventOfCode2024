extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day23input.txt",FileAccess.READ)

var computer_IDs:Array[String]

var connections:Array[Array]

var interconnections:Array[Array]

func _ready() -> void:
	
	while !input_doc.eof_reached():
		var row = input_doc.get_line().split("-",false)
		
		if row.size()>0 and !connections.has([row[1],row[0]]):
			var new_array = [row[0],row[1]]
			connections.append([row[0],row[1]])
	
	#part_one()
	part_two()


func part_two():
	for c in connections:
		if !computer_IDs.has(c[0]):
			computer_IDs.append(c[0])
		if !computer_IDs.has(c[1]):
			computer_IDs.append(c[1])
	
	print("unique:"+str(computer_IDs.size()))
	var count:int =0
	for id in computer_IDs:
		print(count)
		
		var total_connections:Array = [id]
		for id2 in computer_IDs:
			
			var ok:bool = true
			for t in total_connections:
				ok=ok and (connections.has([t,id2]) or connections.has([id2,t]))
			if ok:
				total_connections.append(id2)
			
		interconnections.append(total_connections)
		count+=1
	
	var big_connection:Array = []
	for i in interconnections:
		if i.size()>big_connection.size():
			big_connection = i
	big_connection.sort()
	print(big_connection)

func part_one():
	var count:int = 0
	for c in connections:
		print(count)
		for d in connections:
			if c[1]==d[0]:
				if (connections.has([c[0],d[1]]) or connections.has([d[1],c[0]]))and !(interconnections.has([d[1],c[0],c[1]]) or interconnections.has([c[1],d[1],c[0]])):
					var new_array = [c[0],c[1],d[1]]
					interconnections.append(new_array)
		count+=1
	
	#for i in interconnections:
		#print(i)
	print(interconnections.size())
	
	
	
	var total:int =0
	for i in interconnections:
		for x in i:
			if x.begins_with("t"):
				total+=1
				break
	print("Total:"+str(total))
