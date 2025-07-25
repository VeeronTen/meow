extends Node2D

var _revealed = false

func scare():
	if not _revealed:
		return
	_hide()

func calm():
	if _revealed:
		return
	if $ScaredTimer.is_stopped():
		$ScaredTimer.start()
	
func _on_scared_timer_timeout() -> void:
	_reveal()

func _reveal():
	_revealed = true
	$AnimationPlayer.play("reveal")
	
func _hide():
	_revealed = false
	$ScaredTimer.stop()
	$AnimationPlayer.play("hide")
	
	
