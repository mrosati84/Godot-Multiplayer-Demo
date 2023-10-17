extends Node

@onready var bullet = load("res://bullet.tscn")
@onready var missile = load("res://missile.tscn")

@onready var spawn_point = get_node("/root/World/SpawnPoint")
@onready var players_list_widget = get_node("/root/World/UI/Players/List")

@onready var bullet_seq = 0
@onready var missile_seq = 0

@rpc("any_peer")
func fire():
	var sender_id = multiplayer.get_remote_sender_id()
	var sender = spawn_point.get_node(str(sender_id))

	var b = bullet.instantiate()
	b.name = "bullet_" + str(sender_id) + "_" + str(bullet_seq)
	b.sender = sender.name
	bullet_seq += 1
	
	b.transform = sender.transform.translated(Vector2(80, 0).rotated(sender.global_rotation))

	spawn_point.add_child(b)
	
#TODO refactor this in order to work with many kind of weapons
# so we don't have to copypaste this shit
@rpc("any_peer")
func fire_special():
	var sender_id = multiplayer.get_remote_sender_id()
	var sender = spawn_point.get_node(str(sender_id))

	var m = missile.instantiate()
	m.name = "missile_" + str(sender_id) + "_" + str(missile_seq)
	m.sender = sender.name
	missile_seq += 1
	
	m.transform = sender.transform.translated(Vector2(80, 0).rotated(sender.global_rotation))

	spawn_point.add_child(m)

@rpc("any_peer", "call_local")
func update_list(players_list):
	players_list_widget.clear()
	for p in players_list:
		players_list_widget.add_item(p)
