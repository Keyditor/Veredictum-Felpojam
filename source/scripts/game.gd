extends Node
var on_2d = false
var on_dialog = false
var on_2d_last = false
var on_dialog_last = false

func change_scene(path:String):
	get_tree().change_scene_to_file(path)
	
func _process(delta: float) -> void:
	if on_2d != on_2d_last:
		on_2d_last = on_2d
		print("Mudou on_2d = ",on_2d)
	if on_dialog != on_dialog_last:
		on_dialog_last = on_dialog
		print("Mudou on_dialog = ",on_dialog)
