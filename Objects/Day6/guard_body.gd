extends CharacterBody3D

var move_speed:float = 50

var controller = null

func _physics_process(delta: float) -> void:
	
	velocity = move_speed*transform.basis.z
	velocity.y = -2
	if transform.origin.y<-5:
		velocity = velocity*0
		controller.get_total_travel()
	
	move_and_slide()
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	rotation_degrees.y-=90
	print("ROTATE")
