extends Control

# \\ Inventory UI //

@onready var quick_inv: HBoxContainer = $Quick/QuickInv
@onready var backpack: Control = $Backpack
@onready var backpack_inv: ScrollContainer = $Backpack/BackpackInv
@onready var backpack_items: GridContainer = $Backpack/BackpackInv/BackpackItems


var InvBox = preload("res://Assets/UI/Scenes/Inventory/InvBox.tscn")
var BackpackBox = preload("res://Assets/UI/Scenes/Inventory/BackpackBox.tscn")

func _ready() -> void:
	
	#init
	
	Inventory.changed.connect(add_box)
	add_box()
	drag_and_drop()

func set_destination_slot(slot_type:String):
	
	if Inventory.dragging_item:
		Inventory.destination_slot = slot_type

func check_entered(ui:Control, slot_type:String):
	
	ui.mouse_entered.connect(set_destination_slot.bind(slot_type))
	ui.mouse_exited.connect(set_destination_slot.bind("none"))

func drag_and_drop():
	
	check_entered(quick_inv,"quick")
	check_entered(backpack_inv, "backpack") 

func add_backpack_box():
	var backpack_box:Button = BackpackBox.instantiate()
	
	backpack_box.pressed.connect(func():
		if backpack.visible:
			backpack.hide()
		else:
			backpack.show()
	)
	
	backpack_box.mouse_entered.connect(func():
		set_destination_slot("backpack")
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
		box.source_slot = "quick"
		
		box.mouse_entered.connect(func():
			Inventory.destination_slot = "quick"
		)
		
		quick_inv.add_child(box)
		box._pressed.connect(func():
			set_destination_slot("quick")
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
		
		box.mouse_entered.connect(func():
			set_destination_slot("backpack")
		)
		
		backpack_items.add_child(box)
