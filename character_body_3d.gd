class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var ThirdPersonPosition: Node3D = $ThirdPersonCameraPosition
@onready var RayCast: RayCast3D = $Neck/Camera3D/RayCast3D
@onready var held_pos: Node3D = $Neck/HeldObjectPosition
@onready var propeller = $Propeller
var held_block: Block
static var phys_pos: Vector3

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y += event.relative.x * -0.2
		neck.rotation_degrees.x += event.relative.y * -0.2
		neck.rotation_degrees.x = clamp(neck.rotation_degrees.x,-90,90)
		#neck.rotation_degrees.y = clamp(neck.rotation_degrees.y,-90,90)
	pass

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	pass

func _process(delta: float) -> void:
	
	propeller.visible = flying
	if flying:
		propeller.rotate_y(deg_to_rad(360) * 2 * delta)
	
	if Input.is_action_just_pressed("Recall"):
		held_block = null
	
	if held_block != null:
		held_block.global_position = held_pos.global_position
		#held_block.rotation = camera.rotation
	
	if Input.is_action_just_pressed("TOGGLECAMER"):
		if camera.position==ThirdPersonPosition.position:
			camera.position = neck.position
		else:
			camera.position=ThirdPersonPosition.position
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit(0)
	if Input.is_action_just_pressed("place"):
		if RayCast.is_colliding():
			var place_point = RayCast.get_collision_point()
			var block = preload("res://block.tscn").instantiate()
			block.position = place_point
			get_parent().add_child(block)
	if Input.is_action_pressed("Shoot"):
		var proj_spawn_point = camera.global_position
		var direction = camera.global_basis.z * -1
		var projectile = preload("res://Builder_projectile.tsn.tscn").instantiate()
		projectile.global_position = proj_spawn_point
		projectile.linear_velocity = direction * 50
		get_parent().add_child(projectile)
		#if RayCast.is_colliding():
			#var 
		#print("Shoot")
	if Input.is_action_just_pressed("break"):
		if RayCast.is_colliding() && held_block == null:
			var break_object = RayCast.get_collider()
			print(break_object)
			if break_object is Block:
				#break_object.queue_free()
				var block_position = break_object.global_position
				held_pos.global_position = block_position
				#add_child(break_object)
				break_object.reparent(held_pos,true)
				break_object.held = true
				
				#neck.add_child(break_object)
				break_object.global_position = block_position
				held_block = break_object
		else:
			if held_block != null:
				print("throwing")
				#held_block.global_position = held_block.global_position
				#var cur_pos = held_block.global_position
				#held_block.position = cur_pos
				held_block.held = false
				held_block.reparent(get_parent(),true)
				#held_block.set_collision_layer_value(1,true)
				
				held_block = null
				
			
	

var flying = false

func _physics_process(delta: float) -> void:
	phys_pos = position
	# Add the gravity.
	if not is_on_floor() and not flying:
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Flight"):
		flying = not flying
		velocity.y = 0
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("jump") and flying:
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Downwards") and flying:
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_released("Downwards") and flying:
		velocity.y = 0
	if Input.is_action_just_released("jump") and flying:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Move_left", "Move_right", "Move_foward", "Move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
