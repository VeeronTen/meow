extends Control

@onready var ost = $Ost
@onready var slide_1 = $ColorRect/HBoxContainer/Slide1
@onready var slide_2 = $ColorRect/HBoxContainer/Slide2

var _finishing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _finishing:
		ost.volume_db -= delta * 8
	elif ost.volume_db < 0:
		ost.volume_db += delta * 6

func _on_change_slide_timer_timeout() -> void:
	_next_slide()

func _next_slide():
	if slide_1.visible:
		slide_1.visible = false
		slide_2.visible = true
	elif slide_2.visible and not _finishing:
		_finishing = true
	elif _finishing:
		get_tree().change_scene_to_file("res://intro/intro.tscn")
