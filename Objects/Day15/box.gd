extends StaticBody3D

@onready var wall_rays:Array[RayCast3D] = [$UpRay,$RightRay,$DownRay,$LeftRay]
@onready var box_areas:Array[Array] = [[$BoxUp1,$BoxUp2],[$BoxRight],[$BoxDown1,$BoxDown2],[$BoxLeft]]

func push(dir:Vector2i):
	var target:int = 0
	var relevant_boxes:Dictionary = {self:true}
	match dir:
		Vector2i(1,0):
			target = 1
		Vector2i(-1,0):
			target = 3
		Vector2i(0,1):
			target = 2
		Vector2i(0,-1):
			target = 0
	wall_rays[target].force_raycast_update()
	if wall_rays[target].is_colliding():
		relevant_boxes[self]= false
		return relevant_boxes
	elif sees_boxes(target):
		for b in box_areas[target]:
			if b.is_colliding():
				relevant_boxes.merge(b.get_collider().push(dir))
		return relevant_boxes
	else:
		return relevant_boxes

func sees_boxes(dir):
	var seen:bool = false
	for b in box_areas[dir]:
		seen = seen or b.is_colliding()
	return seen

func move(dir:Vector2i):
	transform.origin.x += dir.x
	transform.origin.z += dir.y


func _on_up_area_body_entered(body: Node3D) -> void:
	box_areas[0].append(body)


func _on_up_area_body_exited(body: Node3D) -> void:
	box_areas[0].erase(body)


func _on_down_area_body_entered(body: Node3D) -> void:
	box_areas[2].append(body)


func _on_down_area_body_exited(body: Node3D) -> void:
	box_areas[2].erase(body)


func _on_left_area_body_entered(body: Node3D) -> void:
	box_areas[3].append(body)


func _on_left_area_body_exited(body: Node3D) -> void:
	box_areas[3].erase(body)


func _on_right_area_body_entered(body: Node3D) -> void:
	box_areas[1].append(body)


func _on_right_area_body_exited(body: Node3D) -> void:
	box_areas[1].erase(body)
