extends Control

var rng = RandomNumberGenerator.new()

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
		get_tree().change_scene_to_file("res://main.tscn")

func _on_texture_button_pressed() -> void:
	_click_sound.pitch_scale = rng.randf_range(0.75, 1.1)
	_click_sound.play()
	_effects.scale *= 1.4
