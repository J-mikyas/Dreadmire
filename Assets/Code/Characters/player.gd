class_name Player
extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED = 600
const FRICTION = 3000

@onready var hand: Node2D = $Hand
@onready var hand_sprite_2d: Sprite2D = $Hand/HandSprite2D

func _physics_process(delta: float) -> void:
	
	# \\ GUN AND HAND SYSTEM //
	
	var mouse_pos = get_global_mouse_position() - global_position
	var mouse_angle = rad_to_deg(mouse_pos.angle())
	
	hand.rotation_degrees = mouse_angle - 180
	
	if not (mouse_angle <= 90 and mouse_angle >= -90):
		hand_sprite_2d.flip_v = true
	else:
		hand_sprite_2d.flip_v = false
	
	# \\ MOVEMENT SYSTEM //
	
	direction = Input.get_vector("left","right","up","down")
	var target_pos = direction * SPEED
	velocity = velocity.move_toward(target_pos, FRICTION * delta)
	
	move_and_slide()

# \\ Invintory System //

var invintory = {
	"quick": [],
	"backpack": []
}

const QUICK_INV_SIZE: int = 4
const BACKPACK_INV_SIZE: int = 10

func append_item(Item_Name:String) -> void:
	if invintory["quick"].size() < QUICK_INV_SIZE: 
		
		invintory["quick"].append(Item_Name)
		print(invintory)
	elif invintory["backpack"].size() < BACKPACK_INV_SIZE:
		
		invintory["backpack"].append(Item_Name)
		print(invintory) 
	else:
		print("Inv is full")

func remove_item(Item_Name:String) -> void:
	
	invintory["quick"].erase(Item_Name)
