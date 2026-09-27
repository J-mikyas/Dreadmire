class_name InvBoxUI
extends Button

signal _pressed

var Amount:int
var Item_Name:String
var Img:Texture2D
var source_slot:String
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
	if hotkey <= 0:
		hotkey_ui.hide()

func _on_pressed() -> void:
	_pressed.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_0 + hotkey:
			_pressed.emit()


#\\ DRAG ITEM SYSTEM //

var drag_item = preload("res://Assets/UI/Scenes/Inventory/DraggedItem.tscn")
var current_drag_item:DraggedItem

func _process(_delta: float) -> void:
	if Inventory.dragging_item and current_drag_item:
		current_drag_item.global_position = get_global_mouse_position()

func _on_button_down() -> void:
	
	await get_tree().create_timer(0.12).timeout
	if self.button_pressed and Inventory.dragging_item == false:
		
		current_drag_item = drag_item.instantiate()
		current_drag_item.img = self.Img
		current_drag_item.global_position = get_global_mouse_position()
		
		if source_slot == "quick":
			self.get_parent().get_parent().get_parent().add_child(current_drag_item)
		else:
			self.get_parent().get_parent().get_parent().get_parent().add_child(current_drag_item)
		
		
		Inventory.dragging_item = true


func _on_button_up() -> void:
	
	if Inventory.dragging_item:
		Inventory.drag_and_drop(Item_Name,Amount,source_slot)
		Inventory.dragging_item = false
		
		if current_drag_item:
			current_drag_item.queue_free()
			current_drag_item = null 
