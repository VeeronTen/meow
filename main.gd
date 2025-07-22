extends Node2D

func _ready() -> void:
	_positionCatToScreenCenter()
	_positionWalls()
	get_viewport().size_changed.connect(_positionWalls)

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
