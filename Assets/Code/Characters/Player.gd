class_name Player
extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO

const SPEED = 600
const FRICTION = 3000

@onready var hand: Node2D = $Hand
@onready var hand_sprite_2d: Sprite2D = $Hand/HandSprite2D
@onready var equiped_item: Marker2D = $Hand/EquipedItem

var can_throw:bool = true

# \\ ON READY //

func _ready() -> void:
	Inventory.equip.connect(equip_item)
	Inventory.unequip.connect(unequip_item)
	Inventory.throw.connect(throw)


func _physics_process(delta: float) -> void:
	
	# \\ HAND SYSTEM //
	
	var mouse_pos = get_global_mouse_position() - global_position
	var mouse_angle = rad_to_deg(mouse_pos.angle())
	
	hand.rotation_degrees = mouse_angle - 180
	
	if not (mouse_angle <= 90 and mouse_angle >= -90):
		hand_sprite_2d.flip_v = true
		
		for item:Inventory_Item in equiped_item.get_children():
			item.flip_v(true)
	else:
		hand_sprite_2d.flip_v = false
		
		for item:Inventory_Item in equiped_item.get_children():
			item.flip_v(false)
	
	
	# \\ MOVEMENT SYSTEM //
	
	direction = Input.get_vector("left","right","up","down")
	var target_pos = direction * SPEED
	velocity = velocity.move_toward(target_pos, FRICTION * delta)
	
	move_and_slide()

# \\ INVENTORY //

func equip_item(item:Item):
	
	unequip_item()
	equiped_item.add_child(item)
	item.global_scale = Vector2.ONE
	item.global_position = equiped_item.global_position

func unequip_item():
	for item in equiped_item.get_children():
		item.queue_free()
		Inventory.equiped_item = null

func throw(world_item_scene:PackedScene, amount) -> void:
	# \\ Spawn world Item //

	var world_item:World_Item = world_item_scene.instantiate()
	world_item.amount = amount
	world_item.position = equiped_item.global_position
	self.get_parent().add_child(world_item)
	world_item.play_throw_anim()
	
	Inventory.remove_item(world_item.item_name, amount)
