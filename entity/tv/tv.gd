extends Node2D

signal screamer_started
signal screamer_ended
signal screamer_interrupted

@export var volume: float = 0.0

@onready var _default_scale = scale
@onready var _default_rotation = rotation

@onready var _default_inner_noise_volume = $NoiseSound.volume_db
@onready var _default_inner_switch_volume = $SwitchSound.volume_db

var _rng = RandomNumberGenerator.new()

var _switching_show_noise_boost = 10
var _screamer_allowed: bool = false

func _ready() -> void:
	$NoiseSound.volume_db = _default_inner_noise_volume + volume
	$SwitchSound.volume_db = _default_inner_switch_volume + volume

func _process(delta: float) -> void:
	scale = lerp(scale, _default_scale, delta * 4)
	rotation = lerp(rotation, _default_rotation, delta * 4)
	var new_noise_volume = _default_inner_noise_volume + volume
	if $Screen/Noise.visible:
		new_noise_volume += _switching_show_noise_boost
	$NoiseSound.volume_db = new_noise_volume
	var new_switch_volume = _default_inner_switch_volume + volume
	$SwitchSound.volume_db = new_switch_volume
	
func switch_show():
	scale = _default_scale * Vector2(1, 1.2)
	rotation = _rng.randf_range(-PI/6, PI/6)
	$SwitchSound.pitch_scale = _rng.randf_range(0.3, 2.5)
	$SwitchSound.play()
	if $ScaryChannelPlayer.is_playing():
		return
	$Screen/Show.visible = false
	$Screen/Noise.visible = true
	$Screen/ScaryShow.visible = false
	$SwitchShowTimer.start()
	
func _on_switch_show_timer_timeout() -> void:
	if _screamer_allowed: 
		_show_screamer()
	else:
		_show_regular_show()	
	
func _show_regular_show():
	var animations = $AnimationPlayer.get_animation_list()
	$AnimationPlayer.get_index()
	var animation_to_play = animations[randi() % animations.size()]
	$AnimationPlayer.play(animation_to_play)
	$Screen/Show.visible = true
	$Screen/Noise.visible = false
	
func _show_screamer():
	screamer_started.emit()
	$Screen/ScaryShow.visible = true
	$ScaryChannelPlayer.play("screamer")

func _on_secret_scenario_scenario_ready() -> void:
	_screamer_allowed = true

func _on_secret_scenario_scenario_not_ready() -> void:
	_screamer_allowed = false
	if $Screen/ScaryShow.visible:
		screamer_interrupted.emit()
		$ScaryChannelPlayer.stop()
		switch_show()
	
func _on_scary_channel_player_animation_finished(_anim_name: StringName) -> void:
	screamer_ended.emit()
