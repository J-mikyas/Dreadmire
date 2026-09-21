class_name World_Item
extends Item


@onready var label: Label = $Label
@export var amount:int = 1

var can_PickUp: bool = false 

func PickUp():
	Inventory.append_item({Item_Name:amount})
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		label.text = "[E]"
		label.show()
		can_PickUp = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		label.hide()
		can_PickUp = false
	
func _physics_process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_E) and can_PickUp:
		PickUp()
