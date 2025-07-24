extends RayCast2D

func clickedTo() -> String:
	position = get_viewport().get_mouse_position()
	force_raycast_update()
	if is_colliding():
		return get_collider().name
	else:
		return ""
