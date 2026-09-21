extends Control

# \\ Inventory UI //

@onready var quick_inv: HBoxContainer = $QuickInv


var InvBox = preload("res://Assets/UI/Scenes/InvBox.tscn")

func _ready() -> void:
	Inventory.changed.connect(add_box)

func add_box():
	
	#erase
	
	for box in quick_inv.get_children():
		box.queue_free()
	
	# populate
	for item:Dictionary in Inventory.inventory["quick"]:
		
		var box = InvBox.instantiate()
		
		var item_name = item.keys()[0]
		var amount = item.values()[0]
		var img = Inventory.get_icon(item_name)
		
		box.Item_Name = item_name
		box.Amount = amount
		box.Img = img
		
		quick_inv.add_child(box)
