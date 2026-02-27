extends Node2D
@onready var video = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_video_stream_player_finished() -> void:
	GAME.change_scene("res://scenes/main_menu.tscn")
