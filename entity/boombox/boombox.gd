extends Node2D

@export var _bus_name: String
@export var _shake_if_above: float = 0.1
@export var _shaked_scale: float = 1.2

@onready var _particles = $CPUParticles2D
@onready var _sprite = $Sprite2D
@onready var _sprite_scale = _sprite.scale
@onready var _bus_index = AudioServer.get_bus_index(_bus_name)
@onready var _spectrum = AudioServer.get_bus_effect_instance(_bus_index, 0)
@onready var _default_volume = AudioServer.get_bus_volume_db(_bus_index)

const _FREQ_MAX = 11050.0

var _prevVolume = 0
var _muted = false
var _simple = false
var _rng = RandomNumberGenerator.new()

func _ready() -> void:
	_particles.scale_amount_min *= _shaked_scale
	_shake_if_needed()
	
func _process(delta):
	_sprite.scale = _sprite.scale.lerp(_sprite_scale, delta * 2)
	if _simple:
		return
	_shake_if_needed()

func change_music_volume(low: bool):
	_muted = low
	var new_volume = _default_volume
	if (_muted):
		new_volume = -20
	AudioServer.set_bus_volume_db(_bus_index, new_volume)

func _shake():
	if (_muted):
		return
	_sprite.scale = _sprite_scale * _shaked_scale
	_particles.restart()
	
func _shake_if_needed():
	if not _simple:
		var volume = _spectrum.get_magnitude_for_frequency_range(0, _FREQ_MAX).length()
		if (volume == 0.0):
			_simple = true
			_shake_if_needed()
		if (volume > _shake_if_above and _prevVolume != volume):
			_prevVolume = volume
			_shake()
	else: 
		while _simple:
			await get_tree().create_timer(_rng.randf_range(_shake_if_above * 5, _shake_if_above * 10)).timeout
			_shake()
