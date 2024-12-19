extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day19input.txt",FileAccess.READ)

var stripes:PackedStringArray
var stripe_lengths:Array[int]
var stripe_sorted:Array[Array]=[]
var towel_list:Array[String]
var max_stripe_length:int = 10
var valid_count:int = 0
var seen_events:Dictionary={}

func _ready() -> void:
	#parse document
	stripes = input_doc.get_line().split(", ")
	input_doc.get_line()
	stripe_sorted.resize(max_stripe_length+1)
	
	for s in stripes:
		stripe_lengths.append(s.length())
	
	#remove redundant stripes, important if you want part one to compile in your lifetime
	#remove_redundancy()
	
	
	
	
	while !input_doc.eof_reached():
		towel_list.append(input_doc.get_line())
	
	towel_list.resize(towel_list.size()-1)
	
	
	print(stripe_sorted)
	#part_one()
	
	part_two()

func part_two():
	var total:int =0
	var count:int = 0
	for towel in towel_list:
		print(str(count)+towel)
		var inc:int = int(total_possible(towel))
		if inc >0:
			valid_count+=1
		total += inc
		count+=1
	
	print("Valid:"+str(valid_count))
	print("possible:"+str(total))
	

func total_possible(input:String):
	
	if seen_events.has(input):
		return seen_events[input]
	
	var possible:int = 0
	
	if input == "":
		return 1
	for s in stripes:
		if input.left(s.length()) == s:
			possible += total_possible(input.right(-s.length()))
	
	seen_events[input] = possible
	
	return possible


func remove_redundancy():
	var hot_letters:Array[String]=["w","u","b","r","g"]
	for s in stripes:
		
		if hot_letters.has(s):
			hot_letters.erase(s)
	
	var new_stripes:PackedStringArray
	for s in stripes:
		var is_hot:bool = s.length() == 1
		for h in hot_letters:
			is_hot = is_hot or s.contains(h)
		if is_hot:
			new_stripes.append(s)
	stripes = new_stripes
	
	
	
	for i in max_stripe_length+1:
		for s in stripes:
			if s.length() == i:
				stripe_sorted[i].append(s)
	stripe_sorted.reverse()
	
	
	var count:int = 1
	for s in stripe_sorted:
		
		if count > 2:
			var new_row:Array
			for stripe in stripe_sorted[-count]:
				if !towel_possible(stripe,count-1):
					new_row.append(stripe)
			stripe_sorted[-count]= new_row
		
		count +=1
	

func part_one():
	
	
	var total:int =0
	var count:int = 0
	for towel in towel_list:
		print(str(count)+towel)
		print(seen_events.size())
		total += int(towel_possible(towel,max_stripe_length+1))
		count+=1
	
	print("possible:"+str(total))






func towel_possible(input:String,limit):
	
	var branches:Array = [[input]]
	
	
	for list in stripe_sorted:
		var reverse:Array = list.duplicate()
		reverse.reverse()
		for stripe in list:
			if stripe.length()>=limit:
				break
			var new_branches:Array
			for b in branches:
				var sub_branch:Array
				if seen_events.has(stripe+str(b)):
					new_branches.append(seen_events[stripe+str(b)])
					#print("memoized")
				else:
					for a in b:
						var branch:PackedStringArray = a.split(stripe,false)
						sub_branch.append_array(branch)
					
					if sub_branch.size()==0:
						return true
					else:
						sub_branch = filter_array(sub_branch)
						sub_branch.sort()
						seen_events[stripe+str(b)]= sub_branch
						new_branches.append(sub_branch)
					
			
			branches.append_array(new_branches)
			#print("Branch prune start")
			branches = filter_array(branches)
			#print("Branch prune end")
		
		for stripe in reverse:
			if stripe.length()>=limit:
				break
			
			var new_branches:Array
			for b in branches:
				var sub_branch:Array
				if seen_events.has(stripe+str(b)):
					new_branches.append(seen_events[stripe+str(b)])
					#print("memoized")
				else:
					for a in b:
						var branch:PackedStringArray = a.split(stripe,false)
						sub_branch.append_array(branch)
					
					if sub_branch.size()==0:
						return true
					else:
						sub_branch = filter_array(sub_branch)
						sub_branch.sort()
						seen_events[stripe+str(b)]= sub_branch
						new_branches.append(sub_branch)
					
			
			branches.append_array(new_branches)
			#print("Branch prune start")
			branches = filter_array(branches)
			#print("Branch prune end")
		
	
	#print(branches)
	return false

func filter_array(input:Array):
	var filtered:Array=[]
	for i in input:
		
		if !filtered.has(i):
			filtered.append(i)
		
	
	return filtered
