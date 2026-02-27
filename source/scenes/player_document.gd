extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/Nome.text = Dialogic.VAR.playerName
	$Sprite2D/Data.text = Dialogic.VAR.playerBirth
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
