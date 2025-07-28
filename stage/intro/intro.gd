extends Control

var rng = RandomNumberGenerator.new()

@onready var _tv = $HBoxContainer/Tv
@onready var _click_ray = $ClickRayCast2D
@onready var _effects = $HBoxContainer/Pivot/Effects
@onready var _click_sound = $ClickSound

@onready var _effects_default_scale = _effects.scale

const _SCALE_TO_PASS = 2
const _TIME_TO_PASS = 0.4
var _time_over_pass = 0

func _process(delta: float) -> void:
	_effects.scale = lerp(_effects.scale, _effects_default_scale, delta * 1.3)
	if (_effects.scale.x > _SCALE_TO_PASS):
		_time_over_pass += delta
	else:
		_time_over_pass = 0
	if _time_over_pass > _TIME_TO_PASS:
		get_tree().change_scene_to_file("res://stage/main/main.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_to = _click_ray.clickedTo()
		if (clicked_to == _tv.name): _tv.switch_show()
			
func _on_texture_button_pressed() -> void:
	_click_sound.pitch_scale = rng.randf_range(0.75, 1.1)
	_click_sound.play()
	_effects.scale *= 1.4
