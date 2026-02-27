extends Node2D
@onready var logos = $logos
@onready var creditos = $creditos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GAME.endGame:
		print("CU")
		creditos.play()
		AudioManager.play_music(preload("res://assets/Solitude1.mp3"))
	else:
		print("CU2")
		logos.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_creditos_finished() -> void:
	GAME.change_scene("res://scenes/main_menu.tscn")
	pass # Replace with function body.


func _on_logos_finished() -> void:
	GAME.change_scene("res://scenes/main_menu.tscn")
	pass # Replace with function body.
