extends Node2D

@onready var up = Vector2.RIGHT.rotated(rotation)
	
func _physics_process(delta):
	if multiplayer.get_unique_id() == 1:
		position += up * 100 * delta

func _on_timer_timeout():
	if multiplayer.get_unique_id() == 1:
		call_deferred("queue_free")
