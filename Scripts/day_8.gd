extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day8input.txt",FileAccess.READ)

var total_grid:Array = []
var relevant_grid:Array = []
#locations of all frequencies sorted by ID
var frequency_list:Dictionary = {}

func _ready() -> void:
	var start_time:int = Time.get_ticks_msec()
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		var new_line:Array = []
		for a in row:
			new_line.append(false)
		relevant_grid.append(new_line)
		total_grid.append(row)
	
	
	#Delete junk line
	total_grid.resize(total_grid.size()-1)
	relevant_grid.resize(relevant_grid.size()-1)
	
	
	#locate all frequencies
	var y:int = 0
	for t in total_grid:
		var x:int = 0
		for s in t:
			if s != ".":
				if frequency_list.has(s):
					frequency_list[s].append(Vector2i(x,y))
				else:
					frequency_list[s] = [Vector2i(x,y)]
			x+=1
		y+=1
	
	
	
	
	#part 1
	#part_one()
	#part2
	part_two()
	
	
	
	var total:int = 0
	for r in relevant_grid:
		for s in r:
			total += int(s)
			
	
	print("Total: "+str(total))
	
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")



func part_two():
	#tag all antinodes in the relevance grid
	for f in frequency_list.keys():
		
		for a in frequency_list[f]:
			for b in frequency_list[f]:
				relevant_grid[b.y][b.x]=true
				if b!=a:
					
					var anti_vector:Vector2i =  Vector2i(a.x-b.x,a.y-b.y)
					var anti_coords:Vector2i= Vector2i(a.x+anti_vector.x,a.y+anti_vector.y)
					var in_bounds:bool = bounds_check(anti_coords)
					while in_bounds:
						relevant_grid[anti_coords.y][anti_coords.x]=true
						anti_coords+=anti_vector
						in_bounds = bounds_check(anti_coords)



func bounds_check(origin:Vector2i):
	return (origin.x > -1 and origin.x <relevant_grid[0].size() and origin.y > -1 and origin.y < relevant_grid.size())

func part_one():
	#tag all antinodes in the relevance grid
	for f in frequency_list.keys():
		
		for a in frequency_list[f]:
			for b in frequency_list[f]:
				if b!=a:
					var anti_coords:Vector2i= Vector2i(a.x+(a.x-b.x),a.y+(a.y-b.y))
					
					if bounds_check(anti_coords):
						relevant_grid[anti_coords.y][anti_coords.x]=true
