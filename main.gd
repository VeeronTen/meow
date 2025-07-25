extends Node2D

#1.  нора с мышкой и посхалка с закрытием ее ночью мячем и сном
#4.  оформление с лоадером
#6.  все расставить при изменении экрана, мяч и тд
# для пасхалки на телике МЫШ
#в конце мяук! как проснулись - прячется навсегда

#5.  рефакетор всего потому что оч много всякого в котокоде
#9.  если не по ссылке доступ к объектам, подсказки лучше? или нужен именно класс нейм
#11. сраный годот спамит фейковыми изменениями (переносами строк) в *.tscn


func _ready() -> void:
	_positionEverething()
	get_viewport().size_changed.connect(_positionEverething)

func _physics_process(_delta: float) -> void:
	var distance_to_tv = $Cat.position.distance_to($Tv.position)
	var new_noise_shift = -distance_to_tv / 30
	$Tv.shift_noise_volume(new_noise_shift)
	
func _positionEverething():
	_positionCatToScreenCenter()
	_positionWalls()
	_positionBoomboxes()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_to = $ClickRayCast2D.clickedTo()
		if (clicked_to == "Cat"):
			$Cat.meow()
		elif (clicked_to == "Lamp"):
			pass
		elif (clicked_to == "Tv"):
			$Tv.switch_show()
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
