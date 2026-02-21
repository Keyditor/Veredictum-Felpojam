extends Area2D

var object: Node2D

@export var orientation: Enum.ConveyorOrientation

@onready var asc_marker: Marker2D = $Ascending
@onready var desc_marker: Marker2D = $Descending

var speed: float = 30
var current_orientation_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	object =  Node2D.new()
	if orientation == Enum.ConveyorOrientation.Asc:
		current_orientation_point = asc_marker
	else:
		current_orientation_point = desc_marker


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	body.move_to_position(orientation)



func _on_body_exited(body: Node2D) -> void:
	body.stop_moving()
