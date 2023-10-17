extends CanvasLayer

@onready var server_join = $PanelContainer/GridContainer/Join
@onready var server_address = $PanelContainer/GridContainer/Address

@onready var player_id = $PanelContainer/GridContainer/ID
@onready var player_life = $PanelContainer/GridContainer/Life
@onready var player_ping = $PanelContainer/GridContainer/Ping

func _ready():
	player_id.hide()
	player_life.hide()
	player_ping.hide()

func _on_join_pressed():
	NetworkManager.start_network(false)
	
	server_join.hide()
	server_address.hide()
	
	player_id.show()
	player_life.show()
	player_ping.show()

func _on_restart_pressed():
	var id = multiplayer.get_unique_id()
	var player = get_node("/root/World/SpawnPoint/" + str(id))
	
	player.rpc("resurrect")


func _on_quit_pressed():
	get_tree().quit()
