extends CharacterBody2D

@export var speed = 400
@export var bullet : PackedScene
@export var life : int = 100

@onready var life_label = get_node("/root/Multiplayer/UI/PanelContainer/GridContainer/Life")
@onready var id_label = get_node("/root/Multiplayer/UI/PanelContainer/GridContainer/ID")
@onready var server = get_node("/root/Multiplayer/Server")

const SERVER : int = 1

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	id_label.text = str(multiplayer.get_unique_id())
	life_label.text = str("Life: " + str(life))
	
	global_position = Vector2.ZERO

func _process(_delta):
	if Input.is_action_just_pressed("fire") and is_multiplayer_authority():
		server.rpc_id(SERVER, "fire")

func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("left", "right", "up", "down") * speed
		look_at(get_global_mouse_position())

		move_and_slide()

@rpc("any_peer")
func die():
	call_deferred("queue_free")

@rpc("any_peer")
func damage(value):
	life -= value
	life_label.text = str("Life: " + str(life))
	if life <= 0:
		die.rpc()
