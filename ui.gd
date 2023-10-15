extends CanvasLayer

func _on_join_pressed():
	NetworkManager.start_network(false)
	$PanelContainer/GridContainer/Join.hide()

func _on_restart_pressed():
	pass
