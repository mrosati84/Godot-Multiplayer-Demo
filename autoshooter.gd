extends Node

func _on_timer_timeout():
	ServerFunctions.rpc_id(1, "fire")
