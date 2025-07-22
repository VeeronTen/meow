extends RigidBody2D

@export var movePower: int = 400
@export var moeowPower: int = 100

@onready var spriteOffset = $Sprite2D.position.x

func _ready() -> void:
	_attachEars()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_left")):
		_move(Vector2.LEFT)
		_rotateRight(false)
	if (Input.is_action_just_pressed("ui_right")):
		_move(Vector2.RIGHT)
		_rotateRight(true)
	if (Input.is_action_just_pressed("ui_select")):
		linear_velocity = Vector2.UP * moeowPower
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
	_rotateEarRight($LeftEar, false, right)
	_rotateEarRight($RightEar, true, right)
	var newSpriteOffset: float
	if (right):
		newSpriteOffset = spriteOffset
	else:
		newSpriteOffset = -spriteOffset
	$Sprite2D.position.x = newSpriteOffset
	$Sprite2D.flip_h = not right
	
func _rotateEarRight(ear: Ear, rightEar: bool, right: bool):
	var z_index = 0
	if (rightEar == right):
		z_index = -1
	ear.z_index = z_index
	ear.rotateEarRight(right)
	
func _playMeow():
	$MeowPlayer.play()
	
func _move(direction: Vector2):
	linear_velocity = direction * movePower
