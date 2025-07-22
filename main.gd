extends Node2D

func _ready() -> void:
	_positionCatToScreenCenter()

func _positionCatToScreenCenter():
	$Cat.position = get_viewport().size / 2
