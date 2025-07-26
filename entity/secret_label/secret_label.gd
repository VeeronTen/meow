extends Node2D

@onready var _not_found = $NotFound
@onready var _found = $Found

func found() -> void:
	_not_found.visible = false
	_found.visible = true
