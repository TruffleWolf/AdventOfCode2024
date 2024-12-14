extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day14input.txt",FileAccess.READ)

var image_path = "user://"

var screenshot_count:int =0
#test grid scale
#var grid_scale:Vector2i = Vector2i(11,7)
var grid_scale:Vector2i = Vector2i(101,103)


var robo_pos:Array[Vector2i] = []
var robo_vel:Array[Vector2i] = []


func _ready():
	
	
	while !input_doc.eof_reached():
		
		var row = input_doc.get_line().split(" ")
		
		var pos_str = row[0].split(",")
		var vel_str = row[-1].split(",")
		
		robo_pos.append(Vector2i(int(pos_str[0]),int(pos_str[-1])))
		robo_vel.append(Vector2i(int(vel_str[0]),int(vel_str[-1])))
	
	robo_pos.resize(robo_pos.size()-1)
	robo_vel.resize(robo_vel.size()-1)
	
	for r in robo_pos:
		
		var new_square:TextureRect = $Display/WhiteSquares/Texturewhite.duplicate()
		$Display/WhiteSquares.add_child(new_square)
		
	
		
	#part 1
	#part_one()
	
	
	

func _process(delta: float) -> void:
	#part 2
	
	part_two()
	print(screenshot_count)



func part_two():
	
	
	
	
	take_screenshot()
	
	

func take_screenshot():
	position_pixels()
	
	var render:bool = false
	
	for r in robo_pos:
		if robo_pos.has(Vector2i(r.x,r.y-1)) and robo_pos.has(Vector2i(r.x,r.y+1)) and robo_pos.has(Vector2i(r.x-1,r.y)) and robo_pos.has(Vector2i(r.x+1,r.y)):
			render= true
	await get_tree().process_frame
	if render:
		#await get_tree().process_frame
		var img = get_viewport().get_texture().get_image()
		img.save_png(image_path+str(screenshot_count)+".png")
	screenshot_count+=1

func position_pixels():
	
	var count:int = 0
		
	for r in robo_pos:
		robo_pos[count]=get_next_wrapped_pos(count)
		
		
		if robo_pos[count].x < 0:
			robo_pos[count].x = grid_scale.x+robo_pos[count].x
			
		if robo_pos[count].y < 0:
			robo_pos[count].y = grid_scale.y+robo_pos[count].y
			
		count+=1
	
	
	count = 0
	for r in robo_pos:
		$Display/WhiteSquares.get_child(count).position = Vector2(r.x,r.y)
		count +=1

func part_one():
	parse_robots()
	
	
	var quads:Array[int] = [0,0,0,0]
	var count:int =0
	for p in robo_pos:
		#convert the negative positions
		if p.x < 0:
			robo_pos[count].x = grid_scale.x+p.x
		if p.y < 0:
			robo_pos[count].y = grid_scale.y+p.y
		
		#organize into grids
		if robo_pos[count].x<grid_scale.x/2:
			if robo_pos[count].y<grid_scale.y/2:
				quads[0]+=1
			elif robo_pos[count].y>(grid_scale.y/2):
				quads[1]+=1
		elif robo_pos[count].x>(grid_scale.x/2):
			if robo_pos[count].y>(grid_scale.y/2):
				quads[3]+=1
			elif robo_pos[count].y<grid_scale.y/2:
				quads[2]+=1
		
		count +=1
	print(quads)
	print("total:"+str(quads[0]*quads[1]*quads[2]*quads[3]))


func parse_robots():
	
	for step in 100:
		var count:int = 0
		
		for r in robo_pos:
			robo_pos[count]=get_next_wrapped_pos(count)
			count+=1
		
	
	


func get_next_wrapped_pos(id:int):
	var new_pos:Vector2i = Vector2i((robo_pos[id].x+robo_vel[id].x)%grid_scale.x,(robo_pos[id].y+robo_vel[id].y)%grid_scale.y)
	
	return Vector2i((robo_pos[id].x+robo_vel[id].x)%grid_scale.x,(robo_pos[id].y+robo_vel[id].y)%grid_scale.y)
