extends Node

signal changed

var inventory = {
	"quick": [],
	"backpack": []
}

const QUICK_INV_SIZE: int = 5
const BACKPACK_INV_SIZE: int = 10

func append_item(Append_Dict:Dictionary):
	
	for slot_type in inventory:
		
		var list:Array = inventory[slot_type]
		
		for i in list.size():
			var item: Dictionary = list[i]

			if item.keys()[0] == Append_Dict.keys()[0]:
				list[i][item.keys()[0]] += Append_Dict.values()[0]
				changed.emit()
				return
	
	
	if inventory["quick"].size() < QUICK_INV_SIZE: 
		
		inventory["quick"].append(Append_Dict.duplicate())
		changed.emit()
	elif inventory["backpack"].size() < BACKPACK_INV_SIZE:
		
		inventory["backpack"].append(Append_Dict.duplicate())
		changed.emit()
	else:
		print("Inv is full")

func remove_item(item_name:String,Amount:int) -> void:
	for list:Array in inventory:
		for item:Dictionary in list:
			if item.keys()[0] == item_name and (item.values()[0] - Amount) > 0:
				item.values()[0] -= Amount
			elif item.keys()[0] == item_name and (item.values()[0] - Amount) < 0:
				list.erase(item)


# \\ ICONS //

var icons:Dictionary = {
	"Test_Item" = preload("res://Assets/Sprites/Tmp/test_item.png")
}

func get_icon(item_name:String) -> Texture2D:
	return icons.get(item_name)

# \\ INVENTORY ITEMS //

var inv_items:Dictionary = {
	"Test_Item" = preload("res://Assets/Scenes/Tmp/test_inv_item.tscn")
}

signal equip
signal unequip
var equiped_item

func toggle_item(item_name: String):
	
	var inv_item = inv_items.get(item_name).instantiate()
	
	if equiped_item and equiped_item.Item_Name == inv_item.Item_Name:
		unequip.emit()
		equiped_item = null
	else:
		equip.emit(inv_item)
		equiped_item = inv_item
	
	
