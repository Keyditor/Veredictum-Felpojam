extends StaticBody3D

@export var cena_2d: PackedScene
@export var Nome = "Trabalhar?"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use():
	#print("FUNCIONA")
	var Nome = "Sair?"
	return ["work_table",cena_2d, "cena", Nome]
