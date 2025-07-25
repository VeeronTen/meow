extends Node2D

func switch_show():
	$Screen/Show.visible = false
	$Screen/Noise.visible = true
	$SwitchShowTimer.start()

func _on_switch_show_timer_timeout() -> void:
	_show()

func _show():
	$Screen/Show.visible = true
	$Screen/Noise.visible = false
