extends CanvasLayer

@onready var server_join = $PanelContainer/GridContainer/Join
@onready var server_address = $PanelContainer/GridContainer/Address

@onready var player_id = $PanelContainer/GridContainer/ID
@onready var player_life = $PanelContainer/GridContainer/Life
@onready var player_ping = $PanelContainer/GridContainer/Ping
@onready var player_nickname = $PanelContainer/GridContainer/Nickname

func generate_random_nickname():
	var rng = RandomNumberGenerator.new()
	var adjectives = ["Brave", "Swift", "Clever", "Curious", "Silent", "Mighty"]
	var nouns = ["Wolf", "Tiger", "Eagle", "Lion", "Bear", "Cheetah"]
	
	var random_adjective = adjectives[randi() % adjectives.size()]
	var random_noun = nouns[randi() % nouns.size()]
	var my_random_number = str(int(rng.randf_range(0, 9999)))
	var nickname = random_adjective + random_noun + my_random_number
	
	return nickname

func _ready():
	player_id.hide()
	player_life.hide()
	player_ping.hide()
	player_nickname.text = generate_random_nickname();

func _on_join_pressed():
	NetworkManager.start_network(false)
	
	server_join.hide()
	server_address.hide()
	
	player_id.show()
	player_life.show()
	player_ping.show()
	
	player_nickname.editable = false
	player_nickname.flat = true
	player_nickname.focus_mode = Control.FOCUS_NONE
	player_nickname.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_restart_pressed():
	var id = multiplayer.get_unique_id()
	var player = get_node("/root/World/SpawnPoint/" + str(id))
	
	player.rpc("resurrect")


func _on_quit_pressed():
	get_tree().quit()
