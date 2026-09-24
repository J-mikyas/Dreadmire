class_name Inventory_Item
extends Item

@onready var item_sprite_2d: Sprite2D = $ItemSprite2D

func flip_v(value:bool):
	item_sprite_2d.flip_v = value

func _input(event: InputEvent) -> void:
	if (event is InputEventKey) and event.keycode == KEY_R:
		Inventory.throw_item(self.item_name)
