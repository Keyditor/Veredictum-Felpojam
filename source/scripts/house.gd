extends StaticBody3D

@export var cena_2d: PackedScene
@export var Nome : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func use(_use:bool = false):
	if _use:
		Dialogic.start("daySkip")
		if GAME.dayPass:
			GAME.dayPass = false
	return ["work_table",cena_2d, "trazicao", Nome]
	
func _on_dialogic_signal(arg):
	if arg == "exitOffice":
		GAME.lastScene = "res://scenes/office/Office.tscn"
		GAME.change_scene("res://scenes/apartments/Apartments.tscn")
