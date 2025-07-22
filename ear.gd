extends RigidBody2D

class_name Ear

@onready var default_gravity_scale = gravity_scale
@onready var default_linear_dampe = linear_damp

func pin(node: Node):
	$PinJoint2D.node_a = node.get_path()

func up():
	gravity_scale = -20.0
	linear_damp = 20
	$EarsDownTimer.start()
	
func rotateEarRight(right: bool):
	$Sprite2D.flip_h = not right
	
func _earDown():
	gravity_scale = default_gravity_scale
	linear_damp = default_linear_dampe
	
func _on_ears_down_timer_timeout() -> void:
	_earDown()
