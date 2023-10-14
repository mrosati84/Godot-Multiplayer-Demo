extends CharacterBody2D

@export var speed = 400

var server : Node
const SERVER : int = 1

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	if is_multiplayer_authority():
		print("I am the authority " + str(multiplayer.get_unique_id()))
	var root = get_tree().root
	server = root.get_node("/root/Multiplayer/Server")
	
func _process(_delta):
	if Input.is_action_just_pressed("fire") and is_multiplayer_authority():
		server.rpc_id(SERVER, "fire")

func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("left", "right", "up", "down") * speed
		look_at(get_global_mouse_position())
	
		move_and_slide()
