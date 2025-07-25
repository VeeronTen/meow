extends Node2D

#1.  нора с мышкой и посхалка с закрытием ее ночью мячем и сном
#2.  кликабельный телевизор, громче при приближении
#4.  оформление с лоадером
#5.  рефакетор всего потому что оч много всякого в котокоде
#6.  все расставить при изменении экрана, мяч и тд
#7.  рандомные звуки по таймеру для эмбиента?
#9.  если не по ссылке доступ к объектам, подсказки лучше?
#11. сраный годот спамит фейковыми изменениями (переносами строк) в *.tscn


func _ready() -> void:
	_positionEverething()
	get_viewport().size_changed.connect(_positionEverething)

func _positionEverething():
	_positionCatToScreenCenter()
	_positionWalls()
	_positionBoomboxes()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if ($ClickRayCast2D.clickedTo() == "Cat"):
			$Cat.meow()
		elif ($ClickRayCast2D.clickedTo() == "Lamp"):
			pass
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
	$Cat.set_sleepy(changeToNight)


func _on_lamp_switched() -> void:
	changeDayTime()
