class_name Block
extends RigidBody3D

@onready var part_area := $Area3D
var held = false
var recalling = false
var start_recall_position: Vector3
var start_recall_scale: Vector3
var recall_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Recall"):
		recalling = true
		held = false
		start_recall_position = position
		start_recall_scale = scale
		set_collision_layer_value(0, false)
		set_collision_layer_value(1, false)
		set_collision_mask_value(0, false)
		set_collision_mask_value(1, false)
		part_area.set_collision_layer_value(1,false)
		part_area.set_collision_layer_value(0,false)
	#pass
	#
func _physics_process(delta: float) -> void:
	
	if recalling:
		recall_time += delta
		
		var player_pos = Player.phys_pos
		
		position = lerp(start_recall_position,player_pos,recall_time)
		scale = lerp(start_recall_scale,Vector3(0,0,0),recall_time)
		if recall_time >= 1:
			queue_free()

	
	for body in part_area.get_overlapping_bodies():
		if body is Node3D and not body is Player and not body is Block and held:
			print(body)
			var parts = preload("res://crash_particles.tscn").instantiate()
			
			#var avg = (position + body.position)/2 
			
			parts.position = global_position
			get_parent().add_child(parts)
	
	pass


#func _on_body_entered(body: Node) -> void:
	#
	#
	#
	#if body is Node3D:
		#print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		#var parts = preload("res://crash_particles.tscn").instantiate()
		#
		#var avg = (position + body.position)/2 
		#
		#parts.position = avg
		#get_parent().add_child(parts)
	#pass # Replace with function body.


#func _on_area_3d_body_entered(body: Node3D) -> void:
	#
	##print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	##var parts = preload("res://crash_particles.tscn").instantiate()
	##
	###var avg = (position + body.position)/2 
	##
	##parts.position = position
	##get_parent().add_child(parts)
	#pass # Replace with function body.
