extends Area3D

var entered:bool = false

func _on_body_entered(body: Node3D) -> void:
	entered = true
	$MeshInstance3D.show()
	print("entered")
