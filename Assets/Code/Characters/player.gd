extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED = 600
const FRICTION = 3000


func _physics_process(delta: float) -> void:
	
	direction = Input.get_vector("left","right","up","down")
	var target_pos = direction * SPEED
	velocity = velocity.move_toward(target_pos, FRICTION * delta)
	
	move_and_slide()
