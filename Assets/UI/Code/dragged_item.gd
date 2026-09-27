class_name DraggedItem
extends Node2D

var img:Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = img
