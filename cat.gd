extends RigidBody2D

@export var movePower: int = 400
@export var moeowPower: int = 100
@export var meowedScale: float = 1.2

@onready var spriteOffset = $Sprite2D.position.x
@onready var spriteYScale = $Sprite2D.scale.y
@onready var mouthSpriteOffset = $Mouth.position.x
@onready var collisionOffset = $CollisionShape2D.position.x

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
		$Sprite2D.scale.y = spriteYScale * meowedScale
	$Sprite2D.scale.y = lerp($Sprite2D.scale.y, spriteYScale, delta * 2)
	
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
	var newMouthSpriteOffset: float
	var newcollisionOffset: float
	if (right):
		newSpriteOffset = spriteOffset
		newMouthSpriteOffset = mouthSpriteOffset
		newcollisionOffset = collisionOffset
	else:
		newSpriteOffset = -spriteOffset
		newMouthSpriteOffset = -mouthSpriteOffset
		newcollisionOffset = -collisionOffset
	$Sprite2D.position.x = newSpriteOffset
	$Sprite2D.flip_h = not right
	$Mouth.position.x = newMouthSpriteOffset
	$CollisionShape2D.position.x = newcollisionOffset
	
func _rotateEarRight(ear: Ear, rightEar: bool, right: bool):
	var z_index = 0
	if (rightEar == right):
		z_index = -1
	ear.z_index = z_index
	ear.rotateEarRight(right)
	
func _playMeow():
	$MeowPlayer.play()
	$Mouth.visible = true
	
func _move(direction: Vector2):
	linear_velocity = direction * movePower


func _on_meow_player_finished() -> void:
	$Mouth.visible = false
