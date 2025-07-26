extends Node

signal scenario_ready
signal scenario_not_ready

@export var _mouse_hole: Node2D
@export var _ball: Node2D
@export var _night: CanvasItem

var _ball_is_hovering_mouse_hole = false
var _it_is_night = false
var _cat_is_sleeping = false

var done = false
var _prev_state = false

func ended():
	done = true
	if _prev_state:
		scenario_not_ready.emit()
		
func _physics_process(_delta: float) -> void:
	_check_all_conditions()

func _check_all_conditions():
	if done:
		return
	_ball_is_hovering_mouse_hole = _ball.position.distance_to(_mouse_hole.position) < 60
	_it_is_night = _night.visible
	var state = _ball_is_hovering_mouse_hole and _it_is_night and _cat_is_sleeping
	if _prev_state != state:
		if state:
			scenario_ready.emit()
		else:
			scenario_not_ready.emit()
	_prev_state = state

func _on_cat_awaked() -> void:
	_cat_is_sleeping = false

func _on_cat_sleeped() -> void:
	_cat_is_sleeping = true
