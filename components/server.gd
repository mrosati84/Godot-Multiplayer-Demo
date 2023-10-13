extends Node

@onready var bullet = load("res://bullet.tscn")
@onready var spawn_point = get_node("/root/Multiplayer/SpawnPoint")
@onready var seq = 0

@rpc("any_peer")
func fire(pos, rot):
	var sender_id = multiplayer.get_remote_sender_id()
	var b = bullet.instantiate()
	b.name = str(sender_id) + str(seq)
	seq += 1
	b.global_position = pos
	b.global_rotation = rot
	
	spawn_point.add_child(b)
	print("FIRE!")
