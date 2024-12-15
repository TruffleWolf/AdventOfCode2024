extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day15input.txt",FileAccess.READ)


var movements:Array[Vector2i]=[]
var map:Array = []
var bot_pos:Vector2i
var relevant_boxes:Array[Vector2i] = []
var can_move:bool = true
var current_step:int = 0

func _ready():
	
	
	#part_one()
	
	part_two()
	

func part_two():
		#parse document
	var map_mode = true
	var start_y:int = 0
	while !input_doc.eof_reached():
		var row = input_doc.get_line().split("")
		
		if row[0]=="":
			map_mode = !map_mode
		elif map_mode:
			var new_row:Array[String]=[]
			var start_x:int = 0
			for r in row:
				match r:
					"#":
						new_row.append("#")
						new_row.append("#")
					"O":
						new_row.append("[")
						new_row.append("]")
					".":
						new_row.append(".")
						new_row.append(".")
					"@":
						new_row.append("@")
						new_row.append(".")
						bot_pos = Vector2i(start_x,start_y)
				start_x+=2
			map.append(new_row)
			start_y+=1
		else:
			for r in row:
				match r:
					"^":movements.append(Vector2i(0,-1))
					">":movements.append(Vector2i(1,0))
					"v":movements.append(Vector2i(0,1))
					"<":movements.append(Vector2i(-1,0))
					
	
	
	parse_robot_2()
	
	calculate_score()


func calculate_score():
	
	var total:int = 0
	var y:int = 0
	for m in map:
		var x:int = 0
		print(m)
		for l in m:
			
			total+=((100*y)+x)*int(l=="[")
			x+=1
		y+=1
	
	print("total:"+str(total))

func part_one():
	#parse document
	var map_mode = true
	var start_y:int = 0
	while !input_doc.eof_reached():
		var row = input_doc.get_line().split("")
		
		if row[0]=="":
			map_mode = !map_mode
		elif map_mode:
			map.append(row)
			var start_x:int = 0
			for r in row:
				if r == "@":
					bot_pos = Vector2i(start_x,start_y)
				start_x+=1
			start_y+=1
		else:
			for r in row:
				match r:
					"^":movements.append(Vector2i(0,-1))
					">":movements.append(Vector2i(1,0))
					"v":movements.append(Vector2i(0,1))
					"<":movements.append(Vector2i(-1,0))
		
	
	
	print(bot_pos)
	
	parse_robot_1()
	
	#for m in map:
		#print(m)
	
	var total:int = 0
	var y:int = 0
	for m in map:
		var x:int = 0
		for l in m:
			
			total+=((100*y)+x)*int(l=="O")
			x+=1
		y+=1
	
	print("total:"+str(total))


func parse_robot_1():
	
	for m in movements:
		
		can_move_1(bot_pos,m,true)

func parse_robot_2():
	var step:int = 0
	
	for m in movements:
		relevant_boxes = []
		
		can_move_2(bot_pos,m,true)
		step+=1

#checks if movement is possible, if an empty space is found return true
#move objects recursivly
func can_move_1(pos:Vector2i,vec:Vector2i,is_bot:bool):
	var new_loc:Vector2i = pos+vec
	
	match map[new_loc.y][new_loc.x]:
		".":
			if is_bot:
				map[new_loc.y][new_loc.x] = "@"
				map[pos.y][pos.x]="."
				bot_pos = new_loc
				return true
			else:
				map[new_loc.y][new_loc.x] = "O"
				map[pos.y][pos.x]="."
			return true
		"#":
			return false
		"O":
			if can_move_1(new_loc,vec,false):
				if is_bot:
					map[new_loc.y][new_loc.x] = "@"
					map[pos.y][pos.x]="."
					bot_pos = new_loc
					return true
				else:
					map[new_loc.y][new_loc.x] = "O"
					map[pos.y][pos.x]="."
				return true
			else:
				return false

func can_move_2(pos:Vector2i,vec:Vector2i,is_bot:bool):
	
	var new_loc:Vector2i = pos+vec
	
	if is_bot:
		match map[new_loc.y][new_loc.x]:
			".":
				map[new_loc.y][new_loc.x] = "@"
				map[pos.y][pos.x]="."
				bot_pos = new_loc
				return true
			"[":
				if can_move_2(new_loc,vec,false):
					for r in relevant_boxes:
						map[r.y][r.x] = "."
						map[r.y][r.x+1]="."
					
					for r in relevant_boxes:
						map[r.y+vec.y][vec.x+r.x]="["
						map[r.y+vec.y][vec.x+r.x+1]="]"
					
					map[new_loc.y][new_loc.x] = "@"
					map[pos.y][pos.x]="."
					bot_pos = new_loc
					return true
			"]":
				if can_move_2(Vector2i(new_loc.x-1,new_loc.y),vec,false):
					for r in relevant_boxes:
						map[r.y][r.x] = "."
						map[r.y][r.x+1]="."
					
					for r in relevant_boxes:
						map[r.y+vec.y][vec.x+r.x]="["
						map[r.y+vec.y][vec.x+r.x+1]="]"
					
					map[new_loc.y][new_loc.x] = "@"
					map[pos.y][pos.x]="."
					bot_pos = new_loc
					return true
			"#":
				return false
	
	else:
		match vec:
			Vector2i(0,-1):
				relevant_boxes.append(pos)
				var can_move:Array[bool]=[true,true]
				match map[new_loc.y][new_loc.x]:
					".":
						can_move[0]= true
					"[":
						can_move[0]= can_move_2(new_loc,vec,false)
					"]":
						can_move[0]= can_move_2(Vector2i(new_loc.x-1,new_loc.y),vec,false)
					"#":
						return false
				
				match map[new_loc.y][new_loc.x+1]:
					".":
						can_move[1]= true
					"[":
						can_move[1]= can_move_2(Vector2i(new_loc.x+1,new_loc.y),vec,false)
					"]":
						pass
					"#":
						return false
				return can_move[0] and can_move[1]
				
			Vector2i(0,1):
				relevant_boxes.append(pos)
				var can_move:Array[bool]=[true,true]
				match map[new_loc.y][new_loc.x]:
					".":
						can_move[0]= true
					"[":
						can_move[0]= can_move_2(new_loc,vec,false)
					"]":
						can_move[0]= can_move_2(Vector2i(new_loc.x-1,new_loc.y),vec,false)
					"#":
						return false
				
				match map[new_loc.y][new_loc.x+1]:
					".":
						can_move[1]= true
					"[":
						can_move[1]= can_move_2(Vector2i(new_loc.x+1,new_loc.y),vec,false)
					"]":
						pass
					"#":
						return false
				return can_move[0] and can_move[1]
			
			Vector2i(-1,0):
				relevant_boxes.append(pos)
				match map[new_loc.y][new_loc.x]:
					".":
						return true
					"]":
						return can_move_2(Vector2i(new_loc.x-1,new_loc.y),vec,false)
					"#":
						return false
				
			Vector2i(1,0):
				relevant_boxes.append(pos)
				match map[new_loc.y][new_loc.x+1]:
					".":
						return true
					"[":
						return can_move_2(Vector2i(new_loc.x+1,new_loc.y),vec,false)
					"#":
						return false
	
