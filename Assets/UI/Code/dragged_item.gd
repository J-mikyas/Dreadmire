class_name DraggedItem
extends Node2D

var img:Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = img

func play_pop_anim():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
