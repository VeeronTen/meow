extends Node2D

func _ready() -> void:
	_positionCatToScreenCenter()
	_positionWalls()
	get_viewport().size_changed.connect(_positionCatToScreenCenter)
	get_viewport().size_changed.connect(_positionWalls)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var screenSizeX = get_viewport().size.x
		if (event.position.x > screenSizeX/2):
			$Cat.move(Vector2.RIGHT)
		else:
			$Cat.move(Vector2.LEFT)
	
func _positionCatToScreenCenter():
	$Cat.position = get_viewport().size / 2
	
func _positionWalls():
	var screenSize = get_viewport().size
	$Walls/Left.position.x = 0
	$Walls/Left.position.y = screenSize.y/2
	$Walls/Right.position.x = screenSize.x
	$Walls/Right.position.y = screenSize.y/2
	$Walls/Bottom.position.x = screenSize.x/2
	$Walls/Bottom.position.y = screenSize.y
