extends Node2D

@export var busName: String
@export var shakeIfAbove: float = 0.1
@export var shakedScale: float = 1.2

@onready var spriteScale = $Sprite2D.scale
@onready var spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(busName),0)
	
const FREQ_MAX = 11050.0
var prevVolume = 0

func _ready() -> void:
	$CPUParticles2D.scale_amount_min *= shakedScale
	
func _process(delta):
	var volume = spectrum.get_magnitude_for_frequency_range(0, FREQ_MAX).length()
	if (volume > shakeIfAbove and prevVolume != volume):
		prevVolume = volume
		shake()
	$Sprite2D.scale = Vector2(lerp($Sprite2D.scale.x, spriteScale.x, delta * 2), lerp($Sprite2D.scale.y, spriteScale.y, delta * 2))

func shake():
	$Sprite2D.scale = spriteScale * shakedScale
	$CPUParticles2D.restart()
