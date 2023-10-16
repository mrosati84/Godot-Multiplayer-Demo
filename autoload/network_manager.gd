extends Node

const player_scene = preload("res://player.tscn")

const PORT = 4242
const ADDR = "127.0.0.1"

@onready var spawn_point = get_node("/root/World/SpawnPoint")
@onready var address = get_node("/root/World/UI/PanelContainer/GridContainer/Address")
var players_list = []
var ping_label
var ping_timer

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
		var address_parts = address.text.strip_edges().split(":")
		peer.create_client(address_parts[0], int(address_parts[1]))
		
		ping_timer = Timer.new()
		ping_timer.set_wait_time(1.0) # 1 second delay
		ping_timer.set_one_shot(false) # Execute cyclically
		ping_timer.timeout.connect(_on_ping_timer_timeout)
		add_child(ping_timer)
		
		ping_timer.start()
		
		ping_label = get_node("/root/World/UI/PanelContainer/GridContainer/Ping");
		update_ping()
		
	multiplayer.multiplayer_peer = peer
	
func _on_ping_timer_timeout():
	update_ping()
	
func update_ping():
	var start_time = Time.get_unix_time_from_datetime_string(Time.get_time_string_from_system())
#	print("Ping?")
	rpc_id(1, "return_ping", start_time)
	
@rpc("any_peer", "call_local")
func return_ping(received_start_time):
	if multiplayer.is_server():
		rpc_id(multiplayer.get_remote_sender_id(), "calculate_ping", received_start_time)

@rpc("any_peer", "call_local")
func calculate_ping(start_time):
	var end_time = Time.get_unix_time_from_datetime_string(Time.get_time_string_from_system())
	var ping = end_time - start_time
	ping_label.text = "Ping: " + str(ping) + " ms"
#	print("Pong!"+ str(ping) +"ms")

func create_player(id):
	# Instantiate a new player for this client.
	var p = player_scene.instantiate()

	# Set the name, so players can figure out their local authority
	p.name = str(id)
	p.global_position = Vector2(0, 0)
	
	players_list.append(str(id))
	
	ServerFunctions.update_list.rpc(players_list)
	
	spawn_point.add_child(p)
	
	print("Player " + p.name + " joined")

func destroy_player(id):
	# remove the player from the list
	
	for i in range(players_list.size()):
		if players_list[i] == str(id):
			players_list.remove_at(i)
			break
	
	ServerFunctions.update_list.rpc(players_list)
	
	# Delete this peer's node.
	spawn_point.get_node(str(id)).queue_free()
	
	print("Player " + str(id) + " disconnected")
