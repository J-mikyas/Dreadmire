class_name InvBoxUI
extends Button

@export var Amount:int
@export var Item_Name:String
@export var Img:Texture2D

@onready var item_name: Label = $Name
@onready var amount: Label = $Amount
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	item_name.text = Item_Name
	amount.text = str(Amount) + "x"
	sprite_2d.texture = Img
