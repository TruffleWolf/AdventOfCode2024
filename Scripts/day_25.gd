extends Node

@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day25input.txt",FileAccess.READ)

var key_grids:Array
var lock_grids:Array

func _ready() -> void:
	
	var current_grid:Array=[-1,-1,-1,-1,-1]
	#0 is new grid,1 is lock,2 is key
	var grid_type:int = 0
	var count:int = 0
	while !input_doc.eof_reached():
		var row = input_doc.get_line().split("",false)
		
		if row.size()==0:
			if grid_type == 1:
				lock_grids.append(current_grid.duplicate())
			elif grid_type == 2:
				key_grids.append(current_grid.duplicate())
			current_grid=[-1,-1,-1,-1,-1]
			grid_type = 0
		else:
			if grid_type == 0:
				if row[0]=="#":
					grid_type = 1
				elif row[0]==".":
					grid_type = 2
			else:
				count = 0
				if grid_type==1:
					
					for r in row:
						if r == ".":
							current_grid[count]+=1
						count+=1
				elif grid_type==2:
					for r in row:
						if r == "#":
							current_grid[count]+=1
						count+=1
	
	var total:int = 0
	for l in lock_grids:
		for k in key_grids:
			total+=int(can_fit(l,k))
	print("Total:"+str(total))

func can_fit(lock,key):
	var fits:bool = true
	var count:int = 0
	for l in lock:
		fits =fits and (lock[count]>=key[count])
		count+=1
	return fits
