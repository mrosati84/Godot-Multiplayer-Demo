extends Node

const PlayerScene = preload("res://player.tscn")

const PORT = 4242
const ADDR = "127.0.0.1"

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
	var p = PlayerScene.instantiate()

	# Set the name, so players can figure out their local authority
	p.name = str(id)
	p.transform = spawn_point.transform
	
	spawn_point.add_child(p)
	print("Player " + p.name + " joined")

func destroy_player(id):
	# Delete this peer's node.
	spawn_point.get_node(str(id)).queue_free()
	print("Player " + str(id) + " disconnected")
