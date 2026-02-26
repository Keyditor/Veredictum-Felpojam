extends CanvasLayer

var is_mouse_over_texture: bool

@onready var canvas_animation_player: AnimationPlayer = $CanvasAnimationPlayer

var has_shown: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible: 
		if not has_shown:
			canvas_animation_player.play("show_information")
			has_shown = true
	else:
		has_shown = false

func _on_button_button_down() -> void:
	canvas_animation_player.play("hide_information")
	await canvas_animation_player.animation_finished
	hide()




func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		canvas_animation_player.play("hide_information")
		await canvas_animation_player.animation_finished
		hide()
