extends Area2D

@export var orientation: Enum.ConveyorOrientation
@export var speed: float = 150.0
@export var time_gap: float

@onready var asc_marker: Marker2D = $Ascending
@onready var desc_marker: Marker2D = $Descending

var start_conveyor: bool

var spawn_point
var limiter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_point = asc_marker.global_position
	
	match GAME.dayCount:
		1:
			Data.person_count = 0
			limiter = 3
		2:
			Data.person_count = 3
			limiter = 6
		3: 
			Data.person_count = 7
			limiter = 9


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if orientation == Enum.ConveyorOrientation.Desc and start_conveyor and not Data.has_spawning_started:
		Data.spawn_mail(Data.person_count, spawn_point, time_gap)
		await get_tree().create_timer(120).timeout
		Data.has_spawning_started = false
	# Depois da terceira pessoa para de spawnar
	if Data.person_count == limiter and Data.has_spawning_started:
		start_conveyor = false

func _on_body_entered(body: Node2D) -> void:
	# Pacote ser "enviado"
	if orientation == Enum.ConveyorOrientation.Asc:
		body.move_to_position(orientation, speed, asc_marker.global_position)
	else:
		body.move_to_position(orientation, speed, desc_marker.global_position)
		

func _on_body_exited(body: Node2D) -> void:
	body.stop_moving()
