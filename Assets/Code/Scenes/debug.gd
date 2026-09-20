extends Node2D
@onready var level: Node2D = $Level
const test_item_tscn = preload("res://Assets/Scenes/Tmp/test_item.tscn")

func _ready() -> void:
	pass
	#spawn_loop()

func spawn_loop() -> void:
	while true:
		await get_tree().create_timer(2.0).timeout
		
		var item_instance = test_item_tscn.instantiate()
		
		item_instance.position = Vector2(976.0,231.0)
		level.add_child(item_instance)
