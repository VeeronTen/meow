extends RigidBody2D

@onready var maxBounceVolume = $BounceSound.volume_db
@onready var defaultSpriteScale = $Sprite2D.scale

var _hadNoSoundsFor = 1.0

func _process(delta: float) -> void:
	_hadNoSoundsFor += delta
	$Sprite2D.scale = lerp($Sprite2D.scale, defaultSpriteScale, delta*4)
	
func _on_body_entered(_body: Node) -> void:
	_playBounce()
	
func _playBounce():	
	$BounceSound.volume_db = lerp(-10.0, maxBounceVolume, clamp(_hadNoSoundsFor, 0, 1))
	$BounceSound.play()
	$Sprite2D.scale = defaultSpriteScale * 0.9
	_hadNoSoundsFor = 0.0
