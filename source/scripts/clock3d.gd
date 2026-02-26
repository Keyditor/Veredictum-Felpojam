extends StaticBody3D
@export var cena_2d: PackedScene
@export var Nome: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func use(_use:bool):
	if _use:
		Nome = "Checar as horas?"
	return ["clock",cena_2d, "dialogo", Nome]
	#get_tree().change_scene_to_file("res://scenes/work_table.tscn")
