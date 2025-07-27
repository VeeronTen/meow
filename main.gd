extends Node2D

#улучшить ридми
#лагает на телефоне
#мяч улетел
#мяч тяжело доставать, упросттить либо подсказкой либо интеракцией с креслом
# перерисовать уши для МЫШЫ
# если будет аутро, то выключить музыку в конце
#всегда пролаг при падении первом в вебе

#динамические размиеры
#print(DisplayServer.screen_get_size())
#print(DisplayServer.window_get_size())

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
	
func changeDayTime(day: bool):
	var night = !day
	$NightFilter.visible = night
	$Boomboxes/BoomboxLeft.change_music_volume(night) 
	$Boomboxes/BoomboxRight.change_music_volume(night)
	$Cat.set_sleepy(night)

func _on_lamp_light_switched(enabled: bool) -> void:
	changeDayTime(!enabled)

func _on_tv_screamer_started() -> void:
	vingetee_scary_player.play("scary")
	
func _on_tv_screamer_ended() -> void:
	vingetee_scary_player.stop()
	$Cat.meow()
	$SecretScenario.ended()
	$MouseHole.hide_forever()
	changeDayTime(true)
	$Lamp.switch()
	$SecretLabel.found()


func _on_tv_screamer_interrupted() -> void:
	vingetee_scary_player.stop()


func _on_first_fall_first_falled() -> void:
	$Cat.meow()
