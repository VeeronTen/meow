extends Node2D

signal switched

@export var spring_constant: float = 100
@export var damping_constant: float = 5
@export var extra_distance_to_switch: float = 80

@onready var original_lamp_position: Vector2 = $Lamp.position

var dragging = false
var switchedThisDrag = false

func _process(_delta: float) -> void:
	queue_redraw()
	
func _physics_process(_delta: float) -> void:
	if dragging:
		_applyDragForce()
		if _lampEnoughToSwitch() and not switchedThisDrag:
			_switch()
		
func _draw() -> void:
	draw_line(Vector2.ZERO, $Lamp.position + Vector2(-4, 0) , Color(0, 0, 0), 7)
	draw_line(Vector2.ZERO, $Lamp.position + Vector2(4, 0), Color(0, 0, 0), 7)
	
func _on_lamp_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_startDragging()
		else:
			_stopDragging()

func  _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			_stopDragging()

func _lampEnoughToSwitch() -> bool:
	var draggedDown = $Lamp.position.y - original_lamp_position.y > 0
	var distnceFromStartEnough = $Lamp.position.distance_to(original_lamp_position) > extra_distance_to_switch
	return draggedDown and distnceFromStartEnough
	
func _applyDragForce():
	var mouse_position = get_viewport().get_mouse_position()
	var displacement_to_mouse = mouse_position - $Lamp.global_position
	var spring_force = displacement_to_mouse * spring_constant
	var damping_force = -$Lamp.linear_velocity * damping_constant
	$Lamp.apply_force(spring_force + damping_force)
	
func _startDragging():
	dragging = true
	
func _stopDragging():
	dragging = false
	switchedThisDrag = false
	
func _switch():
	switchedThisDrag = true
	$SwitchSound.play()
	switched.emit()
