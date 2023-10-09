extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene

func _on_join_pressed():
	peer.create_client("127.0.0.1", 8910)
	multiplayer.multiplayer_peer = peer

func _on_host_pressed():
	peer.create_server(8910)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()

func _add_player(id = 1):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	call_deferred("add_child", player_instance)
