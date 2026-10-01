extends Control

# \\ Inventory UI //

@onready var quick_inv: HBoxContainer = $Quick/QuickInv
@onready var backpack: Control = $Backpack
@onready var backpack_inv: ScrollContainer = $Backpack/BackpackInv
@onready var backpack_items: GridContainer = $Backpack/BackpackInv/BackpackItems


var InvBox = preload("res://Assets/UI/Scenes/Inventory/InvBox.tscn")
var BackpackBox = preload("res://Assets/UI/Scenes/Inventory/BackpackBox.tscn")

var backpack_button:Button

func _ready() -> void:
	#init
	Inventory.slot_resolver = get_slot_at_mouse
	Inventory.changed.connect(add_box)
	add_box()

func get_slot_at_mouse() -> String:
	var mouse_pos = get_global_mouse_position()
	
	if backpack.visible and backpack_inv.get_global_rect().has_point(mouse_pos):
		return "backpack"
	
	if backpack_button.get_global_rect().has_point(mouse_pos):
		return "backpack"
	
	if quick_inv.get_global_rect().has_point(mouse_pos):
		return "quick"
	
	return "none"

func add_backpack_box():
	var box:Button = BackpackBox.instantiate()
	backpack_button = box
	
	box.pressed.connect(func():
		if backpack.visible:
			backpack.hide()
		else:
			backpack.show()
	)
	
	quick_inv.add_child(box)

func add_box():
	
	#erase
	
	for box in quick_inv.get_children():
		box.queue_free()
	for box in backpack_items.get_children():
		box.queue_free()
	
	# populate quick
	for i in Inventory.inventory["quick"].size():
		
		
		
		var box:InvBoxUI = InvBox.instantiate()
		
		var item = Inventory.inventory["quick"][i]
		var item_name = item.keys()[0]
		var amount = item.values()[0]
		var img = Inventory.get_icon(item_name)
		
		box.Item_Name = item_name
		box.Amount = amount
		box.Img = img
		box.hotkey = i + 1
		box.source_slot = "quick"
		
		quick_inv.add_child(box)
		
		box._pressed.connect(func():
			Inventory.toggle_item(item_name)
		)
	
	#add backpack button
	
	add_backpack_box()
	
	# populate backpack
	for i in Inventory.inventory["backpack"].size():
		var box:InvBoxUI = InvBox.instantiate()
		
		var item = Inventory.inventory["backpack"][i]
		var item_name = item.keys()[0]
		var amount = item.values()[0]
		var img = Inventory.get_icon(item_name)
		
		box.Item_Name = item_name
		box.Amount = amount
		box.Img = img
		box.source_slot = "backpack"
		
		backpack_items.add_child(box)
