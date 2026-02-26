extends Control

@onready var settings = $settings
@onready var animator = $settings/AnimationPlayer

func _ready() -> void:
	AudioManager.play_music(preload("res://audio/menu.ogg"))
	$Jogar/RichTextLabel.text="Jogar"
	$Options/RichTextLabel.text="Opções"
	$Fechar/RichTextLabel.text="Sair"
	

func _on_jogar_pressed() -> void:
	GAME.change_scene("res://scenes/apartments/Apartments.tscn")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	if settings.visible==false:
		settings.show()
		animator.play("fall")
		await animator.animation_finished
		$Jogar.visible=false
		$Options.visible=false
		$Fechar.visible=false
	pass # Replace with function body.

func _on_fechar_pressed() -> void:
	get_tree().quit(0)
	pass # Replace with function body.

func _on_jogar_mouse_entered() -> void:
	$Jogar/RichTextLabel.text="[wave amp=50]Jogar[/wave]"


func _on_jogar_mouse_exited() -> void:
	$Jogar/RichTextLabel.text="Jogar"


func _on_options_mouse_entered() -> void:
	$Options/RichTextLabel.text="[wave amp=50]Opções[/wave]"


func _on_options_mouse_exited() -> void:
	$Options/RichTextLabel.text="Opções"


func _on_fechar_mouse_entered() -> void:
	$Fechar/RichTextLabel.text="[wave amp=50]Sair[/wave]"
	

func _on_fechar_mouse_exited() -> void:
	$Fechar/RichTextLabel.text="Sair"



func _on_settings_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		#if settings.visible and $Options.visible:
		$Jogar.visible=true
		$Options.visible=true
		$Fechar.visible=true
		animator.play("fall_2")
		await animator.animation_finished
		settings.hide()
