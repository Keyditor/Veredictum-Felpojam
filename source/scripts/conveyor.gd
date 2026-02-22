extends Area2D

@export var orientation: Enum.ConveyorOrientation
@export var speed: float = 150.0
@export var time_gap: float

@onready var asc_marker: Marker2D = $Ascending
var spawn_point
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_point = asc_marker.global_position
	if orientation == Enum.ConveyorOrientation.Desc:
		Data.spawn_mail(0, spawn_point, time_gap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	body.move_to_position(orientation, speed)
	
	# Pacote ser "enviado"
	if orientation == Enum.ConveyorOrientation.Asc:
		body.send_mail()

func _on_body_exited(body: Node2D) -> void:
	body.stop_moving()
