extends RigidBody2D

func _ready() -> void:
	_attachEars()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_left")):
		linear_velocity = Vector2.LEFT * 400
		_rotateRight(false)
	if (Input.is_action_just_pressed("ui_right")):
		linear_velocity = Vector2.RIGHT * 400
		_rotateRight(true)
	if (Input.is_action_just_pressed("ui_select")):
		_earsUp()
		_playMeow()
	
func _attachEars():
	_attachEar($LeftEar)
	_attachEar($RightEar)
	
func _attachEar(year: Ear):
	year.pin(self)
	
func _earsUp():
	_earUp($LeftEar)
	_earUp($RightEar)

func _earUp(year: Ear):
	year.up()
	
func _rotateRight(right: bool):
	pass
	_rotateEarRight($LeftEar, false, right)
	_rotateEarRight($RightEar, true, right)
	$Sprite2D.flip_h = not right
	
func _rotateEarRight(ear: Ear, rightEar: bool, right: bool):
	pass
	var z_index = 0
	if (rightEar == right):
		z_index = -1
	ear.z_index = z_index
	ear.get_node("Sprite2D").flip_h = not right
	
func _playMeow():
	$MeowPlayer.play()
