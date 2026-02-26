extends Node3D
@onready var Player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	GAME.gameStart = true
	if GAME.lastScene == "res://scenes/office/Office.tscn":
		Player.global_position = Vector3(-11.7, 0, 1.893)
		Player.global_rotation_degrees = Vector3(0, -90, 0)
	elif GAME.lastScene == "res://scenes/main_menu.tscn":
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
	elif GAME.lastScene == "Start":
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		Dialogic.start("startDialog")
	elif GAME.dayCount == 2:
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		Dialogic.start("dayTwo")
	elif GAME.dayCount == 3:
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		Dialogic.start("dayThree")
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialogic_signal(arg):
	if arg == "newDay":
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		if GAME.dayCount == 2:
			Dialogic.start("dayTwo")
		elif GAME.dayCount == 3:
			Dialogic.start("dayThree")
