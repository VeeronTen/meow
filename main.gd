extends Node2D

func _ready() -> void:
	_positionEverething()
	get_viewport().size_changed.connect(_positionEverething)

func _positionEverething():
	_positionCatToScreenCenter()
	_positionWalls()
	_positionBoomboxes()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if ($ClickRayCast.clickedTo() == "Cat"):
			$Cat.meow()
			#todo remove
			changeDayTime()
		elif (event.position.x > $Cat.position.x):
			$Cat.move(Vector2.RIGHT)
		else:
			$Cat.move(Vector2.LEFT)
	
func _positionCatToScreenCenter():
	$Cat.position = get_viewport().size / 2
	
func _positionWalls():
	var screenSize = get_viewport().size
	$Walls/Left.position.x = 0
	$Walls/Left.position.y = screenSize.y/2
	$Walls/Right.position.x = screenSize.x
	$Walls/Right.position.y = screenSize.y/2
	$Walls/Bottom.position.x = screenSize.x/2
	$Walls/Bottom.position.y = screenSize.y
	
func _positionBoomboxes():
	var screenSize = get_viewport().size
	$Boomboxes/BoomboxLeft.position.x = 100
	$Boomboxes/BoomboxLeft.position.y = 100
	$Boomboxes/BoomboxRight.position.x = screenSize.x - 100
	$Boomboxes/BoomboxRight.position.y = 100
	
func changeDayTime():
	var changeToNight = !$NightFilter.visible
	$NightFilter.visible = changeToNight
	$Boomboxes/BoomboxLeft.changeMusicVolume(changeToNight) 
	$Boomboxes/BoomboxRight.changeMusicVolume(changeToNight)	
