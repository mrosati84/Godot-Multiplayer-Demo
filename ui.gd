extends CanvasLayer

func _on_join_pressed():
	NetworkManager.start_network(false)
	$PanelContainer/GridContainer/Join.hide()

func _on_restart_pressed():
	var id = multiplayer.get_unique_id()
	var player = get_node("/root/World/SpawnPoint/" + str(id))
	
	player.rpc("resurrect")
