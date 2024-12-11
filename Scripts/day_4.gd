extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day4input.txt",FileAccess.READ)

var letter_grid:Array[PackedStringArray] =[]

var n_found:int = 0
var nw_found:int = 0
var w_found:int = 0
var sw_found:int = 0
var s_found:int = 0
var se_found:int = 0
var e_found:int = 0
var ne_found:int = 0


func _ready():
	#format the data
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		letter_grid.append(row)
	
	
	#Delete junk line
	letter_grid.resize(letter_grid.size()-1)
	
	#Part1
	#parse_xmas()
	#Part2
	parse_cross_mas()

func parse_cross_mas():
	var total_found:int = 0
	var y:int = 0
	for a in letter_grid:
		var x:int = 0
		for b in a:
			if b == "A" and x>0 and x<a.size()-1 and y>0 and y<letter_grid.size()-1:
				var pos:Vector2 = Vector2(x,y)
				var mas_count:int = 0
				mas_count += int(cross_NE(pos))
				mas_count += int(cross_SE(pos))
				mas_count += int(cross_NW(pos))
				mas_count += int(cross_SW(pos))
				
				if mas_count == 2:
					total_found +=1
			x+=1
		y+=1
	print("total:"+str(total_found))

func parse_xmas():
	var total_found:int = 0
	var y:int = 0
	for a in letter_grid:
		var x:int = 0
		for b in a:
			if b == "X":
				var pos:Vector2 = Vector2(x,y)
				n_found += int(check_N(pos))
				ne_found += int(check_NE(pos))
				e_found += int(check_E(pos))
				se_found += int(check_SE(pos))
				s_found += int(check_S(pos))
				sw_found += int(check_SW(pos))
				w_found += int(check_W(pos))
				nw_found += int(check_NW(pos))
				
			x +=1
		y+=1
	total_found = n_found + ne_found + e_found+se_found+s_found+sw_found+w_found+nw_found
	
	print("total:"+str(total_found))


#Computer, brute force this crossword.
func check_N(coords:Vector2):
	if coords.y <3:
		return false
	return (letter_grid[coords.y-1][coords.x]=="M" and letter_grid[coords.y-2][coords.x]=="A" and letter_grid[coords.y-3][coords.x]=="S")

func check_NE(coords:Vector2):
	if coords.y < 3 or coords.x > letter_grid[0].size()-4:
		return false
	return (letter_grid[coords.y-1][coords.x+1]=="M" and letter_grid[coords.y-2][coords.x+2]=="A" and letter_grid[coords.y-3][coords.x+3]=="S")

func check_E(coords:Vector2):
	if coords.x > letter_grid[0].size()-4:
		return false
	return (letter_grid[coords.y][coords.x+1]=="M" and letter_grid[coords.y][coords.x+2]=="A" and letter_grid[coords.y][coords.x+3]=="S")

func check_SE(coords:Vector2):
	if coords.y > letter_grid.size()-4 or coords.x > letter_grid[0].size()-4:
		return false
	return (letter_grid[coords.y+1][coords.x+1]=="M" and letter_grid[coords.y+2][coords.x+2]=="A" and letter_grid[coords.y+3][coords.x+3]=="S")

func check_S(coords:Vector2):
	if coords.y > letter_grid.size()-4:
		return false
	return (letter_grid[coords.y+1][coords.x]=="M" and letter_grid[coords.y+2][coords.x]=="A" and letter_grid[coords.y+3][coords.x]=="S")

func check_SW(coords:Vector2):
	if coords.x < 3 or coords.y > letter_grid.size()-4:
		return false
	return (letter_grid[coords.y+1][coords.x-1]=="M" and letter_grid[coords.y+2][coords.x-2]=="A" and letter_grid[coords.y+3][coords.x-3]=="S")

func check_W(coords:Vector2):
	if coords.x < 3:
		return false
	return (letter_grid[coords.y][coords.x-1]=="M" and letter_grid[coords.y][coords.x-2]=="A" and letter_grid[coords.y][coords.x-3]=="S")

func check_NW(coords:Vector2):
	if coords.x < 3 or coords.y <3:
		return false
	return (letter_grid[coords.y-1][coords.x-1]=="M" and letter_grid[coords.y-2][coords.x-2]=="A" and letter_grid[coords.y-3][coords.x-3]=="S")


func cross_NW(coords:Vector2):
	return (letter_grid[coords.y-1][coords.x-1]=="M" and letter_grid[coords.y+1][coords.x+1] =="S")

func cross_SW(coords:Vector2):
	return (letter_grid[coords.y+1][coords.x-1]=="M" and letter_grid[coords.y-1][coords.x+1] =="S")

func cross_NE(coords:Vector2):
	return (letter_grid[coords.y-1][coords.x+1]=="M" and letter_grid[coords.y+1][coords.x-1] =="S")

func cross_SE(coords:Vector2):
	return (letter_grid[coords.y+1][coords.x+1]=="M" and letter_grid[coords.y-1][coords.x-1] =="S")
