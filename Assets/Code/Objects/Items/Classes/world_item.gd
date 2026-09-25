class_name World_Item
extends Item

@onready var interact_key: Label = $Visible/Interact_Key
@onready var amount_text: Label = $Visible/Amount
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_PickUp: bool = false 

func _ready() -> void:
	update_amount()

func PickUp():
	Inventory.append_item({item_name:amount})
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

var is_merging:bool = false


func update_amount() -> void:
	if amount > 1:
		amount_text.show()
		amount_text.text = str(amount) + "x"
	else:
		amount_text.hide()

func play_merge_anim() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.15)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func merge(other_item: World_Item) -> void:
	
	is_merging = true
	other_item.is_merging = true
	
	$Visible/MergeRadius.set_deferred("monitoring", false)
	$Visible/MergeRadius.set_deferred("monitorable", false)
	other_item.get_node("Visible/MergeRadius").set_deferred("monitoring", false)
	other_item.get_node("Visible/MergeRadius").set_deferred("monitorable", false)
	
	var tween: Tween = create_tween()
	tween.tween_property(other_item,"position",self.position,0.2)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	
	if is_instance_valid(other_item):
		amount += other_item.amount
		other_item.queue_free()
		update_amount()
		play_merge_anim()
	
	is_merging = false
	
	$Visible/MergeRadius.monitoring = true
	$Visible/MergeRadius.monitorable = true
	other_item.get_node("Visible/MergeRadius").set_deferred("monitoring", true)
	other_item.get_node("Visible/MergeRadius").set_deferred("monitorable", true)
	
	await get_tree().physics_frame
		
	var overlapping_areas = $Visible/MergeRadius.get_overlapping_areas()
	for area in overlapping_areas:
		_on_merge_radius_area_entered(area)


func _on_merge_radius_area_entered(area: Area2D) -> void:
	var other_item = area.get_parent().get_parent()

	if (other_item is World_Item) and not (is_merging or other_item.is_merging) and (self.item_name == other_item.item_name) and not other_item.is_queued_for_deletion():
		if get_instance_id() > other_item.get_instance_id():
			merge(other_item)
