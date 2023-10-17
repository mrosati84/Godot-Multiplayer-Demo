extends Node2D

@export var speed : float = 300.0
@export var damage : float = 20.0

@onready var up = Vector2.RIGHT.rotated(rotation)
@onready var spawn_point = get_node("/root/World/SpawnPoint")

# contains the name of the peer that has originated the bullet by shooting
var sender : String

func _physics_process(delta):
	if multiplayer.is_server():
		position += up * speed * delta

func _on_timer_timeout():
	if multiplayer.is_server():
		despawn_bullet.rpc()

func _on_body_entered(body):
	if multiplayer.is_server():
		print("[SERVER] HIT! bullet " + sender + " -> " + body.name)
		var target = spawn_point.get_node(str(body.name))
		var target_id = int(str(target.name))
		
		if target.name != sender:
			target.rpc_id(target_id, "damage", damage)
			despawn_bullet.rpc()

@rpc("any_peer", "call_local")
func despawn_bullet():
	call_deferred("queue_free")
