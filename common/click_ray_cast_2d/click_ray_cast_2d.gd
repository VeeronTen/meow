extends RayCast2D

func clickedTo() -> String:
	global_position = get_global_mouse_position()
	force_raycast_update()
	if is_colliding():
		return get_collider().name
	else:
		return ""
		
