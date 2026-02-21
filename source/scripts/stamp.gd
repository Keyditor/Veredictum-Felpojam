extends Node2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO
@export var stamp_mark_kind: Enum.StampMarks

var stamp_mark_load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stamp_mark_load = load(Data.StampsMarks[stamp_mark_kind])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_holding:
		position = get_global_mouse_position() - grab_offset


func _on_button_button_down() -> void:
	is_holding = true
	grab_offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	is_holding = false



func _on_press_stamp_button_down() -> void:
	var stamp_mark = stamp_mark_load.instantiate()
	var object_hited = point_hits_object(global_position)
	set_stamp_mark(stamp_mark, object_hited, global_position, stamp_mark_kind)
	

func set_stamp_mark(mark: Node2D, parent_object: Node2D, pos: Vector2, StampMarkKind):
	if parent_object.is_in_group("objects"):
		var mark_local_position = parent_object.to_local(pos)
		
		mark.position = mark_local_position
		parent_object.add_child(mark)
		
		# Verificar se o objeto já está carimbado, se sim vai receber o valor no is_stamped como inválido
		var object_stamp = parent_object.current_mail[parent_object.mail]["is_stamped"]
		if object_stamp == Enum.StampMarks.Neuter:
			parent_object.current_mail[parent_object.mail]["is_stamped"] = StampMarkKind
			
		# Verificar se o objeto já foi carimbado e se sim, o carimbo é igual ao que está sendo feito?
		elif object_stamp == StampMarkKind:
			parent_object.current_mail[parent_object.mail]["is_stamped"] = StampMarkKind
		else:
			parent_object.current_mail[parent_object.mail]["is_stamped"] = Enum.StampMarks.Invalid

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
