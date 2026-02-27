extends Node3D
@onready var Player = $Player
var PLACEHOLDER = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$CorridorD1/Sign.visible = false
	$CorridorD2/Sign.visible = false
	$CorridorD3/Sign.visible = false
	$CorridorD5/Sign.visible = false
	$CorridorD6/Sign.visible = false
	$CorridorD7/Sign.visible = false
	$CorridorD8/Sign.visible = false
	$CorridorD4/Sign.visible = false

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
	for i in Data.sent_mail:
		match i["name"]:
			"Dulce Martins":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD1/Sign.visible = true
				else:
					$CorridorD1/Sign.visible = false
			"Vicente Fonseca":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD2/Sign.visible = true
				else:
					$CorridorD2/Sign.visible = false
			"João Brasil":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD3/Sign.visible = true
				else:
					$CorridorD3/Sign.visible = false
			"Odete Oliveira":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD5/Sign.visible = true
				else:
					$CorridorD5/Sign.visible = false
			"Benedito Dias":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD6/Sign.visible = true
				else:
					$CorridorD6/Sign.visible = false
			"Ignácio Américo":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD7/Sign.visible = true
				else:
					$CorridorD7/Sign.visible = false
			"Mario Gonzaga":
				if i["state"] == Enum.StampMarks.Good:
					$CorridorD8/Sign.visible = true
				else:
					$CorridorD8/Sign.visible = false
	if GAME.dayCount == 3 and GAME.dayPass:
		$CorridorD4/Sign.visible = true
	pass

func _on_dialogic_signal(arg):
	if arg == "newDay":
		Player.global_position = Vector3(7.509, 0, -1.37)
		Player.global_rotation_degrees = Vector3(0, 180, 0)
		if GAME.dayCount == 2:
			Dialogic.start("dayTwo")
			AudioManager.stop_music()
			AudioManager.play_music(preload("res://assets/VS_gameplay.mp3"),false)
		elif GAME.dayCount == 3:
			Dialogic.start("dayThree")
			AudioManager.stop_music()
			AudioManager.play_music(preload("res://assets/VS_gameplay.mp3"),false)
