extends StaticBody2D

func _process(delta):
	if Global.is_dragging:
		visible = true
	
