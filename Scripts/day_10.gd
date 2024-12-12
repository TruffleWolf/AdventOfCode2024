extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day9input.txt",FileAccess.READ)

var topo_map:Array[Array]= []

const START_HEIGHT:int = 0
const END_HEIGHT:int = 9

func _ready():
	
	
	while !input_doc.eof_reached():
		var row:PackedStringArray = input_doc.get_line().split("")
		
		
