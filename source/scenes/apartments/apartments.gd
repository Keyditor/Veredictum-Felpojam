extends Node3D
@onready var Player = $Player
var PLACEHOLDER = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(preload("res://assets/VS_gameplay.mp3"),false)
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
	if PLACEHOLDER:
		$CorridorD1/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD2/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD3/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD5/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD6/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD7/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD8/Sign.visible = true
	if PLACEHOLDER:
		$CorridorD4/Sign.visible = true
	
	pass

func _on_dialogic_signal(arg):
	if arg == "newDay":
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		if GAME.dayCount == 2:
			Dialogic.start("dayTwo")
			AudioManager.play_music(preload("res://assets/VS_gameplay.mp3"),false)
		elif GAME.dayCount == 3:
			Dialogic.start("dayThree")
			AudioManager.play_music(preload("res://assets/VS_gameplay.mp3"),false)
