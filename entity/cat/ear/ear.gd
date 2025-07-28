class_name Ear
extends RigidBody2D

@onready var _joint: PinJoint2D = $PinJoint2D
@onready var _ear_down_timer: Timer = $EarsDownTimer
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _default_gravity_scale: float = gravity_scale
@onready var _default_linear_dampe: float = linear_damp

func _on_ears_down_timer_timeout() -> void:
	_earDown()



func pin(node: Node) -> void:
	_joint.node_a = node.get_path()

func up() -> void:
	gravity_scale = -20.0
	linear_damp = 20
	_ear_down_timer.start()
	
func rotateEarRight(right: bool) -> void:
	_sprite.flip_h = not right



func _earDown() -> void:
	gravity_scale = _default_gravity_scale
	linear_damp = _default_linear_dampe
