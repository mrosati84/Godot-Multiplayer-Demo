extends Node2D

@export var speed : float = 100.0
@export var damage : float = 50.0

@onready var up = Vector2.RIGHT.rotated(rotation)
@onready var spawn_point = get_node("/root/World/SpawnPoint")

# contains the name of the peer that has originated the missile by shooting
var sender : String

var target_enemy = null
var last_direction = Vector2.ZERO

func _ready():
	select_random_enemy()

func select_random_enemy():
	var players = get_tree().get_nodes_in_group("players")
	
	if players.size() > 0:
		target_enemy = players[randi() % players.size()] # Scegli un nemico casuale dalla lista

func _physics_process(delta):
	if multiplayer.is_server():
		# Controlla se l'obiettivo esiste e fa ancora parte dell'albero della scena		
		# se è vivo e che non sia chi ha sparato il missile
		if target_enemy \
		and target_enemy.alive \
		and target_enemy.name != sender: 
			var direction = (target_enemy.global_position - global_position).normalized()
			var angle_to_target = atan2(direction.y, direction.x)
			
			# il missile segue l'obiettivo
			rotation = angle_to_target
			position += direction * speed * delta
			
			last_direction = direction # Aggiorna l'ultima direzione con la direzione corrente
		else:
			select_random_enemy() # Seleziona un nuovo nemico se l'obiettivo attuale non è valido
			
			position += last_direction * speed * delta
			
			#@TODO
			# Fai esplodere il missile se nessun nemico è _più_ disponibile
#			if multiplayer.is_server():
#				despawn_missile.rpc()
			
func _on_timer_timeout():
	if multiplayer.is_server():
		despawn_missile.rpc()

func _on_body_entered(body):
	if multiplayer.is_server():
		print("[SERVER] HIT! Missile " + sender + " -> " + body.name)
		var target = spawn_point.get_node(str(body.name))
		var target_id = int(str(target.name))
		
		if target.name != sender:
			target.rpc_id(target_id, "damage", damage)
			despawn_missile.rpc()

@rpc("any_peer", "call_local")
func despawn_missile():
	call_deferred("queue_free")
