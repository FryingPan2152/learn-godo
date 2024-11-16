extends RigidBody3D
@onready var check_area := $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	for body in check_area.get_overlapping_bodies():
		var place_point = global_position
		var block = preload("res://block.tscn").instantiate()
		block.position = place_point
		get_parent().add_child(block)
		queue_free()
		break
	#if check_area.get_overlapping_bodies().size() > 0:
		#queue_free()
	
	#move_and_collide(linear_velocity)
	pass
