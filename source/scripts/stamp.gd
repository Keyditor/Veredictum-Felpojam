extends Node2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

var stamp_mark_preload = preload("res://scenes/objects/stamp_mark.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_holding:
		position = get_global_mouse_position() - grab_offset


func _on_button_button_down() -> void:
	is_holding = true
	grab_offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	is_holding = false



func _on_press_stamp_button_down() -> void:
	print("Pressionou o carimbo")
	var object = point_hits_object(global_position)
	var stamp_mark = stamp_mark_preload.instantiate()
	stamp_mark.position = object.to_local(global_position)
	if object.is_in_group("objects"):
		object.add_child(stamp_mark)

func point_hits_object(point: Vector2) -> Node2D:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space_state.intersect_point(query)
	
	for hit in result:
		if hit.collider.is_in_group("objects"):
			return hit.collider
	return Node2D.new()
