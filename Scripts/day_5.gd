extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day5input.txt",FileAccess.READ)

var rules:Array[Array]= []
var updates:Array[Array]= []

func _ready():
	
	#format the data
	var rules_strings:Array[String] =[]
	var update_strings:Array[String] =[]
	while !input_doc.eof_reached():
		var line:String = input_doc.get_line()
		if line.contains("|"):
			rules_strings.append(line)
		elif line.contains(","):
			update_strings.append(line)
	
	for r in rules_strings:
		var rule_split:Array = r.split("|")
		rules.append([int(rule_split[0]),int(rule_split[1])])
	
	for u in update_strings:
		var update_split:Array = u.split(",")
		var new_array = []
		for s in update_split:
			new_array.append(int(s))
		
		updates.append(new_array)
	
	
	var filtered_updates:Array[Array]= []
	var broken_updates:Array[Array]= []
	#filter the data
	for u in updates:
		
		if rules_check(u):
			filtered_updates.append(u)
		else:
			broken_updates.append(u)
	#Part 1
	#updates = filtered_updates
	
	
	updates = correct_updates(broken_updates)
	
	#count the pages
	var total:int = 0
	for u in updates:
		total += u[floori(u.size()/2)]
		
	
	print(total)


func correct_updates(input:Array[Array]):
	
	var repaired_array:Array[Array]= []
	for i in input:
		
		var unsorted:bool = true
		var count = 0
		print("INPUT:"+str(i))
		while unsorted:
			var target = i[-1-count]
			for r in rules:
				if r[0]==target:
					#relevant rule
					if i.has(r[1]) and i.find(target)>i.find(r[1]):
						i.erase(target)
						i.insert(i.find(r[1]),target)
						count = -1
			count +=1
			unsorted = count < i.size()
		print("OUTPUT:"+str(i))
		repaired_array.append(i)
	
	return repaired_array


func rules_check(input:Array):
	var valid:bool = true
	for i in input:
		
		for r in rules:
			if r[0]==i:
				#relevant rule found for this page
				if input.has(r[1]) and input.find(i)>input.find(r[1]):
					valid = false
				
		
	
	return valid
