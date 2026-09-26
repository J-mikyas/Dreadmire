extends Control

# \\ Inventory UI //

@onready var quick_inv: HBoxContainer = $QuickInv
@onready var backpack_inv: ScrollContainer = $BackpackInv
@onready var backpack_items: GridContainer = $BackpackInv/BackpackItems


var InvBox = preload("res://Assets/UI/Scenes/InvBox.tscn")
var BackpackBox = preload("res://Assets/UI/Scenes/BackpackBox.tscn")

func _ready() -> void:
	Inventory.changed.connect(add_box)
	add_box()

func add_backpack_box():
	var backpack_box:Button = BackpackBox.instantiate()
	
	backpack_box.pressed.connect(func():
		if backpack_inv.visible:
			backpack_inv.hide()
		else:
			backpack_inv.show()
	)
	
	quick_inv.add_child(backpack_box)

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
		
		backpack_items.add_child(box)
