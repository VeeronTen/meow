extends RayCast2D

signal first_falled

func _process(_delta: float) -> void:
	if is_colliding():
		first_falled.emit()
		queue_free()
