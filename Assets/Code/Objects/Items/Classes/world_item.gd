class_name World_Item
extends Item

@onready var interact_key: Label = $Visible/Interact_Key
@onready var amount_text: Label = $Visible/Amount
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var amount:int = 1

var can_PickUp: bool = false 

func _ready() -> void:
	update_amount()

func PickUp():
	Inventory.append_item({Item_Name:amount})
	queue_free()

func _on_proximity_prompt_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		interact_key.text = "[E]"
		interact_key.show()
		can_PickUp = true

func _on_proximity_prompt_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		interact_key.hide()
		can_PickUp = false
		

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E and can_PickUp:
			PickUp()

# \\ Merge Logic //

func update_amount() -> void:
	if amount > 1:
		amount_text.show()
		amount_text.text = str(amount) + "x"
	else:
		amount_text.hide()

func merge(other_item: World_Item) -> void:
	
	amount += other_item.amount
	other_item.queue_free()
	update_amount()

func _on_merge_radius_area_entered(area: Area2D) -> void:
	var other_item = area.get_parent().get_parent()

	if (other_item is World_Item) and (Item_Name == other_item.Item_Name) and not other_item.is_queued_for_deletion():
		if get_instance_id() > other_item.get_instance_id():
			merge(other_item)
