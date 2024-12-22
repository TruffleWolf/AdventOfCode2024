extends Node


@onready var input_doc:FileAccess = FileAccess.open("res://Inputs/Day22input.txt",FileAccess.READ)

var buyers:Array[int]
var new_secrets:Array[int]
var sec_change:Array[int]
var purchase_dict:Dictionary

func _ready() -> void:
	
	while !input_doc.eof_reached():
		buyers.append(int(input_doc.get_line()))
	buyers.resize(buyers.size()-1)
	
	
	
	#part_one()
	
	part_two()

func part_two():
	
	var secret64:int = 0
	var secret32:int = 0
	var secret2048:int = 0
	var secret:int = 0
	var count:int = 0
	for b in buyers:
		new_secrets = []
		sec_change = []
		secret = b
		new_secrets.append(b%10)
		for i in 2000:
			secret64 = 64 * secret
			secret = secret ^ secret64
			secret = secret%16777216
			secret32 = secret/32
			secret = secret ^ secret32
			secret = secret%16777216
			secret2048 = secret*2048
			secret = secret ^ secret2048
			secret = secret%16777216
			sec_change.append(new_secrets[i]-(secret%10))
			new_secrets.append(secret%10)
		var seq:String = ""
		var seen:Array[String] = []
		for p in 1997:
			seq = str([sec_change[p],sec_change[p+1],sec_change[p+2],sec_change[p+3]])
			if seen.has(seq):
				pass
			elif purchase_dict.has(seq):
				purchase_dict[seq].append(new_secrets[p+4])
				seen.append(seq)
			else:
				purchase_dict[seq] = [new_secrets[p+4]]
				seen.append(seq)
		print(count)
		count +=1
		
	
	
	
	var total:int = 0
	for n in purchase_dict.keys():
		var sum:int = 0
		for t in purchase_dict[n]:
			sum+=t
		total = maxi(sum,total)
	print("Total"+str(total))

func part_one():
	var secret64:int = 0
	var secret32:int = 0
	var secret2048:int = 0
	var secret:int = 0
	for b in buyers:
		secret = b
		for i in 2000:
			secret64 = 64 * secret
			secret = secret ^ secret64
			secret = secret%16777216
			secret32 = secret/32
			secret = secret ^ secret32
			secret = secret%16777216
			secret2048 = secret*2048
			secret = secret ^ secret2048
			secret = secret%16777216
		new_secrets.append(secret)
	
	print(new_secrets)
	
	var total:int = 0
	for n in new_secrets:
		total+=n
	print("Total"+str(total))
