extends Node

@onready var bullet = load("res://bullet.tscn")
@onready var spawn_point = get_node("/root/World/SpawnPoint")
@onready var players_list_widget = get_node("/root/World/UI/Players/List")
@onready var seq = 0

@rpc("any_peer")
func fire():
	var sender_id = multiplayer.get_remote_sender_id()
	var sender = spawn_point.get_node(str(sender_id))

	var b = bullet.instantiate()
	b.name = str(sender_id) + str(seq)
	b.sender = sender.name
	seq += 1
	
	b.transform = sender.transform.translated(Vector2(80, 0).rotated(sender.global_rotation))

	spawn_point.add_child(b)

@rpc("any_peer", "call_local")
func update_list(players_list):
	players_list_widget.clear()
	for p in players_list:
		players_list_widget.add_item(p)
