extends Node

const player_scene = preload("res://player.tscn")

const PORT = 4242
const ADDR = "127.0.0.1"

var players = []

@onready var spawn_point = get_node("/root/World/SpawnPoint")

func _ready():
	# Start the server if Godot is passed the "--server" argument,
	# and start a client otherwise.
	if "--server" in OS.get_cmdline_args():
		start_network(true)

func start_network(server: bool):
	var peer = ENetMultiplayerPeer.new()
	if server:
		multiplayer.peer_connected.connect(create_player)
		multiplayer.peer_disconnected.connect(destroy_player)
		
		peer.create_server(PORT)
		print('server listening on {addr}:{port}'.format({"addr": ADDR, "port": PORT}))
	else:
		peer.create_client(ADDR, PORT)

	multiplayer.multiplayer_peer = peer

func create_player(id):
	# Instantiate a new player for this client.
	var p = player_scene.instantiate()

	# Set the name, so players can figure out their local authority
	p.name = str(id)
	p.global_position = Vector2(0, 0)

	players.append(str(id))
	
	spawn_point.add_child(p)
	p.rpc("update_player_list", players)
	
	print("Player " + p.name + " joined")

func destroy_player(id):
	# remove the player from the list
	for i in range(players.size()):
		if players[i] == str(id):
			players.remove_at(i)
	
	var to_remove = spawn_point.get_node(str(id))
	to_remove.rpc("update_player_list", players)
	
	# Delete this peer's node.
	spawn_point.get_node(str(id)).queue_free()
	
	print("Player " + str(id) + " disconnected")
