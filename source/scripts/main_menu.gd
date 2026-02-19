extends Control

@onready var settings = $settings
@onready var animator = $settings/AnimationPlayer
func _on_jogar_pressed() -> void:
	GAME.change_scene("res://scenes/office/Office.tscn")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	if settings.visible==false:
		settings.show()
		animator.play("fall")
	pass # Replace with function body.

func _on_fechar_pressed() -> void:
	get_tree().quit(0)
	pass # Replace with function body.
