class_name InvBoxUI
extends Button

signal _pressed

var Amount:int
var Item_Name:String
var Img:Texture2D
var hotkey:int

@onready var item_name: Label = $Name
@onready var amount: Label = $Amount
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hotkey_ui: Label = $Hotkey

func _ready() -> void:
	item_name.text = Item_Name
	amount.text = str(Amount) + "x"
	sprite_2d.texture = Img
	hotkey_ui.text = str(hotkey)

func _on_pressed() -> void:
	_pressed.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_0 + hotkey:
			_pressed.emit()
