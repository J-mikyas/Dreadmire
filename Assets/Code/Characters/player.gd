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

var invintory: Array

func append_item(Item_Name:String) -> void:
	invintory.append(Item_Name)
	print(invintory)

func remove_item(Item_Name:String) -> void:
	invintory.erase(Item_Name)
