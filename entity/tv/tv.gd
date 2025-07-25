extends Node2D

@onready var _default_scale = scale
@onready var _default_rotation = rotation
@onready var _default_noise_volume = $NoiseSound.volume_db

var _rng = RandomNumberGenerator.new()

var _switching_show_noise_boost = 10
var _noise_shift_volume = 0

func _process(delta: float) -> void:
	scale = lerp(scale, _default_scale, delta * 4)
	rotation = lerp(rotation, _default_rotation, delta * 4)
	var new_noise_volume = _default_noise_volume + _noise_shift_volume
	if $Screen/Noise.visible:
		new_noise_volume += _switching_show_noise_boost
	$NoiseSound.volume_db = new_noise_volume
	
func switch_show():
	$Screen/Show.visible = false
	$Screen/Noise.visible = true
	$SwitchShowTimer.start()
	$SwitchSound.pitch_scale = _rng.randf_range(0.3, 2.5)
	$SwitchSound.play()
	scale = _default_scale * Vector2(1, 1.2)
	rotation = _rng.randf_range(-PI/6, PI/6)

func shift_noise_volume(shift_volume: float):
	_noise_shift_volume = shift_volume
	
func _on_switch_show_timer_timeout() -> void:
	_show()

func _show():
	var animations = $AnimationPlayer.get_animation_list()
	var animation_to_play = animations[randi() % animations.size()]
	$AnimationPlayer.play(animation_to_play)
	$Screen/Show.visible = true
	$Screen/Noise.visible = false
