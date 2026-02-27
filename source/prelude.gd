extends Node2D
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.start("prelude")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialogic_signal(arg):
	if arg == "dayOne":
		GAME.playerName = Dialogic.VAR.playerName
		GAME.playerBirth = Dialogic.VAR.playerBirth
		anim.play("day1prelude")
		await anim.animation_finished
		GAME.change_scene("res://scenes/apartments/Apartments.tscn")
