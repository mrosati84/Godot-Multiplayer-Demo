extends Node2D

@export var speed : float = 300.0
@export var damage : float = 20.0

@onready var up = Vector2.RIGHT.rotated(rotation)
@onready var spawn_point = get_node("/root/Multiplayer/SpawnPoint")

# contains the name of the peer that has originated the bullet by shooting
var sender : String

func _physics_process(delta):
	if multiplayer.is_server():
		position += up * speed * delta

func _on_timer_timeout():
	if multiplayer.is_server():
		despawn.rpc()

func _on_body_entered(body):
	if multiplayer.is_server():
		print("I am the server, and " + body.name + " has been hit by " + sender)
		var target = spawn_point.get_node(str(body.name))
		target.rpc_id(int(str(target.name)), "damage", damage)
		call_deferred("queue_free")

@rpc("any_peer", "call_local")
func despawn():
	call_deferred("queue_free")
