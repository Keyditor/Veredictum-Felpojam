extends Node2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

@export var stamp_mark_kind: Enum.StampMarks

var stamp_mark_load

var hited_object: Node2D

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

func _on_stamp_head_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and hited_object:
				var stamp_mark = stamp_mark_load.instantiate()
				var object_hited = hited_object
				set_stamp_mark(stamp_mark, object_hited, global_position, stamp_mark_kind)

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

func _on_stamp_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("objects"):
		hited_object = body



func _on_stamp_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("objects"):
		hited_object = Node2D.new()
