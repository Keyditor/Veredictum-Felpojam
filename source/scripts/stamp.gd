extends Node2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO
var ink_count: int

@export var stamp_mark_kind: Enum.StampMarks

@onready var good_stamp: Sprite2D = $GoodStamp
@onready var bad_stamp: Sprite2D = $BadStamp

var stamp_mark_load

var hited_object: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stamp_mark_load = load(Data.StampsMarks[stamp_mark_kind])
	if stamp_mark_kind == Enum.StampMarks.Good:
		good_stamp.visible = true
		bad_stamp.visible = false
	else:
		bad_stamp.visible = true
		good_stamp.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_holding:
		position = get_global_mouse_position() - grab_offset



func _on_stamp_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_holding = event.pressed
				grab_offset = get_global_mouse_position() - global_position
			else:
				is_holding = false
			get_viewport().set_input_as_handled() # Impede que o sinal do click passe para outros elementos

func _on_stamp_head_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and hited_object:
				var stamp_mark = stamp_mark_load.instantiate()
				var object_hited = hited_object
				set_stamp_mark(stamp_mark, object_hited, global_position, stamp_mark_kind)
				
				
				print(ink_count)

func set_stamp_mark(mark: Node2D, parent_object: Node2D, pos: Vector2, StampMarkKind):
	if parent_object.is_in_group("mails") and ink_count > 0:
		print(parent_object)
		var mark_local_position = parent_object.to_local(pos)
		mark.position = mark_local_position
		parent_object.add_child(mark)
		
		# Verificar se o objeto já está carimbado, se sim vai receber o valor no is_stamped como inválido
		var current_mail_mark = parent_object.stamped
		if current_mail_mark == Enum.StampMarks.Neuter:
			parent_object.stamped = StampMarkKind
		# Verificar se o objeto já foi carimbado e se sim, o carimbo é igual ao que está sendo feito?
		elif current_mail_mark == StampMarkKind:
			parent_object.stamped = StampMarkKind
		else:
			parent_object.stamped = Enum.StampMarks.Invalid
		
		# Diminuir a quantidade de tinta no carimbo
		ink_count -= 1
	
	elif parent_object.is_in_group("mails") and ink_count <= 0:
		# Pequeno diálogo para ajudar o jogador a entender que deve sempre recarregar de tinta
		Dialogic.start("acabou_tinta")

	elif parent_object.is_in_group("inks"):
		print("Ink object")
		if parent_object.ink_type == stamp_mark_kind:
			ink_count = 3
			print("Molhou de tinta! Pronto pra ser usado mais 3 vezes")
		else:
			Dialogic.start("molhar_com_cor_diferente")

func _on_stamp_area_body_entered(body: Node2D) -> void:
	hited_object = body



func _on_stamp_area_body_exited(body: Node2D) -> void:
	hited_object = Node2D.new()
