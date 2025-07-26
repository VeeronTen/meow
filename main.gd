extends Node2D

#4.  оформление с лоадером

# все постоянные чеки сменить на сигналы
#5.  рефакетор всего потому что оч много всякого в котокоде

@onready var vingetee_scary_player = $Cat/Camera2D/VingetteScaryPlayer

var distance_to_scare_mouse = 300

func _physics_process(_delta: float) -> void:
	var distance_to_tv = $Cat.position.distance_to($Tv.position)
	var new_noise_shift = -distance_to_tv / 30
	$Tv.shift_noise_volume(new_noise_shift)
	var distance_to_mouse_hole = $Cat.position.distance_to($MouseHole.position)
	if (distance_to_mouse_hole < distance_to_scare_mouse):
		$MouseHole.scare()
	else:
		$MouseHole.calm()
	
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
	
func changeDayTime():
	var changeToNight = !$NightFilter.visible
	$NightFilter.visible = changeToNight
	$Boomboxes/BoomboxLeft.changeMusicVolume(changeToNight) 
	$Boomboxes/BoomboxRight.changeMusicVolume(changeToNight)
	$Cat.set_sleepy(changeToNight)


func _on_lamp_switched() -> void:
	changeDayTime()

func _on_tv_screamer_started() -> void:
	vingetee_scary_player.play("scary")
	
func _on_tv_screamer_ended() -> void:
	vingetee_scary_player.stop()
	$Cat.meow()
	$SecretScenario.ended()
	$MouseHole.hide_forever()


func _on_tv_screamer_interrupted() -> void:
	vingetee_scary_player.stop()


func _on_first_fall_first_falled() -> void:
	$Cat.meow()
