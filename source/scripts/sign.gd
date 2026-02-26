extends StaticBody3D

@export var cena_2d: PackedScene
@export var Nome : String
@export var Dialogo : String
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
		Dialogic.start(Dialogo)
	return ["none",cena_2d, "dialogo", Nome]
	
func _on_dialogic_signal(arg):
	if arg == Dialogo:
		pass
	pass
	
func _on_dTimer():
		GAME.lastScene = "res://scenes/office/Office.tscn"
		GAME.change_scene("res://scenes/apartments/Apartments.tscn")
