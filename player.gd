extends CharacterBody2D

@export var speed = 400

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _process(_delta):
	if Input.is_action_pressed("fire"):
		print("Fire")

func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("left", "right", "up", "down") * speed
		look_at(get_global_mouse_position())
	
	move_and_slide()
