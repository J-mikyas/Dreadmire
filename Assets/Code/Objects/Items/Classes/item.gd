class_name Item
extends Area2D

@export var Item_Name : String
@onready var label: Label = $Label
var can_PickUp: bool = false 
var Current_Body: Player


func PickUp(player:Player):
	player.append_item(Item_Name)
	print("You picked up item " + Item_Name + ".")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		label.text = "[E]"
		label.show()
		can_PickUp = true
		Current_Body = body

func _on_body_exited(body: Node2D) -> void:
	label.hide()
	can_PickUp = false
	
func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_E) and can_PickUp:
		PickUp(Current_Body)
