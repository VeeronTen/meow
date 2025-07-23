extends RigidBody2D

@export var movePower: int = 400
@export var moeowPower: int = 100
@export var meowedScale: float = 1.2

@onready var collisionOffset = $CollisionShape2D.position.x
@onready var spriteYScale = $Pivot/Sprite2D.scale.y
#todo не нравится что при мяуке может развернуться
#всратая коллизия с мячем
#- окно с птичкой, будет улетать при мягко возле нее
#- случайные звуки или звуки передвижения
#- светильник с ручкой, если дёрнуть - смена дня и ночи
#- кликабельный телевизор, громче при приближении
#- поставка с вторым котом, после мягкой в углу
#оформление с лоадером
#рефакетор всего потому что оч много всякого в котокоде
#все расставить, мяч и тд

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	_attachEars()
	_startBlinking()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_left")):
		move(Vector2.LEFT)
	if (Input.is_action_just_pressed("ui_right")):
		move(Vector2.RIGHT)
	if (Input.is_action_just_pressed("ui_select")):
		_meow()
	$Pivot/Sprite2D.scale.y = lerp($Pivot/Sprite2D.scale.y, spriteYScale, delta * 2)
	
func move(direction: Vector2):
	wakeUp()
	$MovePlayer.play()
	$MovePlayer.pitch_scale = rng.randf_range(0.3, 2.5)
	linear_velocity = direction * movePower
	_rotateRight(direction.x > 0)
	
func _startBlinking():
	var timeTillNextBlink = rng.randf_range(1.3, 3)
	get_tree().create_timer(timeTillNextBlink).timeout.connect(_startBlinking)
	$AnimationTree.set("parameters/BlinkShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
func _meow():
	wakeUp()
	linear_velocity = Vector2.UP * moeowPower
	_earsUp()
	_playMeow()
	$Pivot/Sprite2D.scale.y = spriteYScale * meowedScale
	
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
	var newcollisionOffset: float
	var newScale
	if (right):
		newcollisionOffset = collisionOffset
		newScale = 1
	else:
		newcollisionOffset = -collisionOffset
		newScale = -1
	$Pivot.scale.x = newScale
	$CollisionShape2D.position.x = newcollisionOffset
	
func _rotateEarRight(ear: Ear, rightEar: bool, right: bool):
	var newZIndex = 0
	if (rightEar == right):
		newZIndex = -1
	ear.z_index = newZIndex
	ear.rotateEarRight(right)
	
func _playMeow():
	$MeowPlayer.play()
	$MeowPlayer.pitch_scale = rng.randf_range(0.75, 1.1)
	$AnimationTree.set("parameters/MeowShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_meow()
		get_viewport().set_input_as_handled()


func _on_sleep_timer_timeout() -> void:
	_sleep()

func _sleep():
	$AnimationTree.set("parameters/SleepingBlend/blend_amount", 1.0)
	$Pivot/SleepParticles.emitting = true
	
func wakeUp():
	$SleepTimer.start()
	$Pivot/SleepParticles.emitting = false
	$AnimationTree.set("parameters/SleepingBlend/blend_amount", 0)
