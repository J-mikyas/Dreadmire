extends Node

signal changed

const QUICK_INV_SIZE: int = 5
const BACKPACK_INV_SIZE: int = 10

var inventory = {
	"quick": [],
	"backpack": []
}

var inventory_sizes = {
	"quick": QUICK_INV_SIZE,
	"backpack": BACKPACK_INV_SIZE
}

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

func append_item_slot(Append_Dict:Dictionary, slot:String):
	
	for item:Dictionary in inventory[slot]:
		if Append_Dict.keys()[0] == item.keys()[0]:
			item[item.keys()[0]] += Append_Dict.values()[0]
			return
	
	if inventory[slot].size() < inventory_sizes[slot]:
		inventory[slot].append(Append_Dict.duplicate())
		return
	else:
		print("Inv is full")
		return

func remove_item(item_name:String,amount:int) -> void:
	
	for slot_type in inventory:
		
		var list:Array = inventory[slot_type]
		
		for i in list.size():
			
			var item:Dictionary = list[i]
			
			if item.keys()[0] == item_name and (item.values()[0] - amount) > 0:
				
				var key = item.keys()[0]
				
				item[key] -= amount
				changed.emit()
				return
			elif item.keys()[0] == item_name and (item.values()[0] - amount) <= 0:
				list.remove_at(i)
				unequip.emit()
				changed.emit()
				return

func remove_item_slot(item_name:String,amount:int, slot:String):
	var list:Array = inventory[slot]

	for i in list.size():
		var item:Dictionary = list[i]

		if item.keys()[0] == item_name:
			if item.values()[0] - amount > 0:
				item[item.keys()[0]] -= amount
			else:
				list.remove_at(i)

			changed.emit()
			return

func get_amount(item_name:String):
	
	for item:Dictionary in inventory["quick"]:
		if item.keys()[0] == item_name:
			return item.values()[0]

# \\ INVENTORY ITEMS //

var item_info:Dictionary = {
	"Test_Item" = {
		"inv" = preload("res://Assets/Scenes/Tmp/test_inv_item.tscn"),
		"world" = preload("res://Assets/Scenes/Tmp/test_item.tscn"),
		"icon" = preload("res://Assets/Sprites/Tmp/test_item.png")
		}
}

func get_icon(item_name:String) -> Texture2D:
	var info_dict:Dictionary = item_info.get(item_name)
	return info_dict.get("icon")

func get_world_item(item_name:String):
	var info_dict:Dictionary = item_info.get(item_name)
	return info_dict.get("world")

func get_inv_item(item_name:String):
	var info_dict:Dictionary = item_info.get(item_name)
	return info_dict.get("inv")

signal equip
signal unequip
signal throw
var equiped_item: Inventory_Item

func toggle_item(item_name: String):
	
	var inv_item:Inventory_Item = get_inv_item(item_name).instantiate()
	
	if equiped_item and equiped_item.item_name == inv_item.item_name:
		unequip.emit()
		equiped_item = null
	else:
		equip.emit(inv_item)
		equiped_item = inv_item

func throw_item(item_name:String,amount) -> void:
	throw.emit(get_world_item(item_name),amount)
	
# \\ DRAG AND DROP //

var dragging_item:bool = false
var destination_slot:String = "none"

func drag_and_drop(item_name:String, item_amount:int, source_slot:String):
	
	if not destination_slot == "none":
		
		append_item_slot({item_name:item_amount},destination_slot)
		remove_item_slot(item_name,item_amount,source_slot)
	
	changed.emit()
