extends Node2D

@export var speed : float = 100.0
@export var damage : float = 50.0

@onready var up = Vector2.RIGHT.rotated(rotation)
@onready var spawn_point = get_node("/root/World/SpawnPoint")

# contains the name of the peer that has originated the missile by shooting
var sender : String

var target_enemy = null

func _ready():
	select_random_enemy()

func select_random_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies") # Ottieni tutti i nodi nel gruppo "enemies"
	
	if enemies.size() > 0:
		target_enemy = enemies[randi() % enemies.size()] # Scegli un nemico casuale dalla lista

func _physics_process(delta):
	if multiplayer.is_server():
		if target_enemy and target_enemy.is_inside_tree() and target_enemy.alive: # Controlla se l'obiettivo esiste e fa ancora parte dell'albero della scena
			var direction = (target_enemy.global_position - global_position).normalized()
			
			# Calcola l'angolo tra la posizione del missile e la posizione del nemico
			var angle_to_target = atan2(direction.y, direction.x)
			
			# Imposta la rotazione del missile sull'angolo calcolato
			rotation = angle_to_target
			
			position += direction * speed * delta
		else:
			select_random_enemy() # Seleziona un nuovo nemico se l'obiettivo attuale non è valido
			
func _on_timer_timeout():
	if multiplayer.is_server():
		despawn_missile.rpc()

func _on_body_entered(body):
	if multiplayer.is_server():
		print("I am the server, and " + body.name + " has been hit with missile by " + sender)
		var target = spawn_point.get_node(str(body.name))
		var target_id = int(str(target.name))
		
		target.rpc_id(target_id, "damage", damage)
		despawn_missile.rpc()

@rpc("any_peer", "call_local")
func despawn_missile():
	call_deferred("queue_free")
