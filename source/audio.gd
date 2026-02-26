extends Node

@onready var BGM = $BGM
@onready var SFX = $SFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_music(stream):
	if BGM.stream == stream and BGM.playing: return
	BGM.stream = stream
	BGM.play()

func play_effect(stream):
	if SFX.stream == stream and SFX.playing: return
	SFX.stream = stream
	SFX.play()
