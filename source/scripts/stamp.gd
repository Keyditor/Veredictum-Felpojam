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



func _on_stamp_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print(event.pressed)
				is_holding = event.pressed
				grab_offset = get_global_mouse_position() - global_position
			else:
				is_holding = false
	
#
#func _on_button_button_up() -> void:
	#is_holding = false
	


func _on_stamp_head_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var stamp_mark = stamp_mark_load.instantiate()
				var object_hited = point_hits_object(global_position)
				set_stamp_mark(stamp_mark, object_hited, global_position, stamp_mark_kind)

#func _input(event):
	#if event is InputEventMouseButton and event.pressed:
		#if get_rect().has_point(to_local(event.position)):
			#print("Clicou!")

#func _on_press_stamp_button_down() -> void:
	#var stamp_mark = stamp_mark_load.instantiate()
	#var object_hited = point_hits_object(global_position)
	#set_stamp_mark(stamp_mark, object_hited, global_position, stamp_mark_kind)

func set_stamp_mark(mark: Node2D, parent_object: Node2D, pos: Vector2, StampMarkKind):
	if parent_object.is_in_group("objects"):
		var mark_local_position = parent_object.to_local(pos)
		mark.position = mark_local_position
		parent_object.add_child(mark)
		
		# Verificar se o objeto já está carimbado, se sim vai receber o valor no is_stamped como inválido
		var current_mail_mark = parent_object.mail_info.stamped
		if current_mail_mark == Enum.StampMarks.Neuter:
			parent_object.mail_info.stamped = StampMarkKind
		# Verificar se o objeto já foi carimbado e se sim, o carimbo é igual ao que está sendo feito?
		elif current_mail_mark == StampMarkKind:
			parent_object.mail_info.stamped = StampMarkKind
		else:
			parent_object.mail_info.stamped = Enum.StampMarks.Invalid
func point_hits_object(point: Vector2) -> Node2D:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space_state.intersect_point(query)
	
	for hit in result:
		var node = hit.collider
		while node:
			if node.is_in_group("objects"):
				print(hit.collider)
				return node
			node = node.get_parent()
	return Node2D.new()
