extends StaticBody3D

@export var cena_2d: PackedScene
@export var Nome : String
@export var Owner : String
#@onready var dTimer = $"../../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dTimer.timeout.connect(_on_dTimer)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(_use:bool = false):
	if _use:
		if Owner == "Player":
			Dialogic.VAR.ownerSign = GAME.playerName
		else:
			Dialogic.VAR.ownerSign = Owner
		Dialogic.start("signDialog")
	return ["none",cena_2d, "dialogo", Nome]
	
func _on_dialogic_signal(arg):
	if arg == Owner:
		pass
	pass
	
func _on_dTimer():
		GAME.lastScene = "res://scenes/office/Office.tscn"
		GAME.change_scene("res://scenes/apartments/Apartments.tscn")
