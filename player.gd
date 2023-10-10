extends CharacterBody2D

@export var speed = 400

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("left", "right", "up", "down") * speed
	
	move_and_slide()
