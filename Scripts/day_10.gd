extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day10input.txt",FileAccess.READ)

var topo_map:Array[Array]= []



const START_HEIGHT:int = 0
const END_HEIGHT:int = 9

func _ready():
	var start_time:int = Time.get_ticks_msec()
	#parse the document
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		var new_row:Array = []
		
		for r in row:
			new_row.append(int(r))
		
		topo_map.append(new_row)
	
	#Delete junk line
	topo_map.resize(topo_map.size()-1)
	
	
	var total:int = 0
	var y:int = 0
	for t in topo_map:
		var x:int = 0
		for s in t:
			if s == 0:
				total += scan_trail(Vector2i(x,y))
			x+=1
		y+=1
	
	print("total:"+str(total))
	print("Elapsed:"+str(Time.get_ticks_msec()-start_time)+"ms")

func scan_trail(input:Vector2i):
	var stage:int = 0
	var target_locations:Array = [input]
	while stage < 9:
		var new_locations:Array = []
		for t in target_locations:
			if is_at_location(Vector2i(t.x,t.y-1),stage+1):
				new_locations.append(Vector2i(t.x,t.y-1))
			if is_at_location(Vector2i(t.x,t.y+1),stage+1):
				new_locations.append(Vector2i(t.x,t.y+1))
			if is_at_location(Vector2i(t.x-1,t.y),stage+1):
				new_locations.append(Vector2i(t.x-1,t.y))
			if is_at_location(Vector2i(t.x+1,t.y),stage+1):
				new_locations.append(Vector2i(t.x+1,t.y))
		target_locations = new_locations
		stage+=1
	
	#uncomment for part 1
	target_locations = filter_array(target_locations)
	
	return target_locations.size()

func filter_array(input:Array):
	var result:Array = []
	for t in input:
		if !result.has(t):
			result.append(t)
	return result

func is_at_location(pos:Vector2i,num:int):
	return pos.x>-1 and pos.y > -1 and pos.x<topo_map[0].size() and pos.y<topo_map.size() and topo_map[pos.y][pos.x] == num
