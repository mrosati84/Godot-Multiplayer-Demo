extends CharacterBody2D

@export var speed = 200

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	
	move_and_slide()
