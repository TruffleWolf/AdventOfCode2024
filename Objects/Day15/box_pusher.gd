extends CharacterBody3D

var movements:Array[Vector2i]
var step:int = 0
var collider = []
var controller = null
var push_mode:bool = false
func _physics_process(delta: float) -> void:
	
	if movements.size()>0 and step<movements.size():
		
		if push_mode:
			print(step)
			print(movements[step])
			$RayCast3D.force_raycast_update()
			if $RayCast3D.is_colliding():
				print("stop")
				step+=1
			elif collider:
				var test_list:Dictionary = collider[0].push(movements[step])
				print(test_list)
				var test:bool = true
				for t in test_list.keys():
					test = test and test_list[t]
				if test:
					for t in test_list.keys():
						t.move(movements[step])
					move()
				step+=1
			else:
				print("Pos"+str(transform.origin))
				move()
				step+=1
		else:
			match movements[step]:
				Vector2i(1,0):
					rotation_degrees.y = 90
				Vector2i(-1,0):
					rotation_degrees.y = 270
				Vector2i(0,1):
					rotation_degrees.y = 0
				Vector2i(0,-1):
					rotation_degrees.y = 180
			
		
		push_mode = !push_mode
	if step==movements.size():
		
		controller.calculate_score()
		process_mode = PROCESS_MODE_DISABLED
	

func move():
	transform.origin.x+=movements[step].x
	transform.origin.z +=movements[step].y
	print("newPos"+str(transform.origin))

func start_moving(list:Array):
	
	movements = list

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	collider.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	
	collider.erase(body)
