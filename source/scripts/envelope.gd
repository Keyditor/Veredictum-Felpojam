extends RigidBody2D

var is_holding: bool = false
var is_over_box: bool = false
var grab_offset := Vector2.ZERO
var is_open: bool = false

var is_moving: bool = false
var is_on_conveyor: bool = true
var conveyor_speed: float
var max_speed = 2000

var initial_pos: Vector2
var final_pos: Vector2

@export var mails_within: Array = []
@export var stamped: Enum.StampMarks
@export var person_detail: Texture

var conveyor_orientation: Enum.ConveyorOrientation

@onready var sprite_2d: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_mouse: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var object
var information_canvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	angular_damp = 10
	linear_damp = 6
	gravity_scale = 0
	
	information_canvas = get_tree().get_nodes_in_group("work_table")[0].get_node("InformationCanvas")
	animation_player.play("pop_up")


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_holding:
		var target = get_global_mouse_position() - grab_offset
		var direction = target - global_position
		#
		#var stiffness = 30.0
		#var damping = 5.0
		
		# var force = direction * stiffness - state.linear_velocity * damping
		state.linear_velocity = direction * 30
	else:
		#state.linear_velocity = Vector2.ZERO
		if state.linear_velocity.length() > max_speed:
			state.linear_velocity = state.linear_velocity.normalized() * max_speed
			
		if global_position == final_pos and conveyor_orientation == Enum.ConveyorOrientation.Desc:
				state.linear_velocity = Vector2.RIGHT * 3000

func _physics_process(delta: float) -> void:
	if is_moving:
		if not is_holding and is_on_conveyor:
			position = position.move_toward(final_pos, conveyor_speed * delta)

func move_to_position(orientation: Enum.ConveyorOrientation, speed, final: Vector2):
	is_moving = true
	is_on_conveyor = true
	conveyor_orientation = orientation
	conveyor_speed = speed
	final_pos = final

func stop_moving():
	is_moving = false
	is_on_conveyor = false
	
# Mostrar detalhes com cartas
func show_information():
	information_canvas.get_node("Panel/TextureRect").texture = person_detail
	information_canvas.visible = true

func send_mail():
	if mails_within.size()>0:
		Data.add_to_in_scene_mail(mails_within[0].sender_name, stamped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if global_position == final_pos and not is_holding:
		if conveyor_orientation == Enum.ConveyorOrientation.Asc:
			animation_player.play("pop_out")
	if is_on_conveyor:
		is_moving = true
	
	if object and is_open:
		if object.is_in_group("objects"):
			if object.mail_info.mail_type == Enum.MailTypes.Letter:
				if object.is_in_group("objects") and is_over_box and not object.is_holding:
					mails_within.append(object.mail_info)
					object.animation_player.play("pop_out")
					animation_player.play("put_inside")
				if object.is_in_group("objects") and is_over_box and object.is_holding:
					object.apply_outline()
				elif object.is_in_group("objects"):
					object.remove_outline()
	
	# Para que a caixa consiga empurrar os itens quando estiver fechada
	if not is_open:
		set_collision_mask_value(2, true)
		if object:
			object.set_collision_mask_value(5, true)
	elif object:
		if object.is_in_group("objects"):
			if object.mail_info.mail_type == Enum.MailTypes.Letter:
				set_collision_mask_value(2, false)
				#set_collision_layer_value(2, false)
				if object:
					
					object.set_collision_mask_value(5, false)
			else:
				set_collision_mask_value(2, true)
			
		


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: # Impede que a encomenda seja puxada junto com o carimbo
				is_holding = true
				grab_offset = get_global_mouse_position() - global_position
				is_moving = false
				linear_velocity = Vector2.ZERO
				
				# Animação de fechar a caixa/pacote
				if event.double_click:
					if is_open:
						animation_player.play("close_envelope")
					else:
						animation_player.play("open_envelope")
					is_open = not is_open
			else:
				is_holding = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			show_information()


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_over_box = true
	object = body




func _on_area_2d_body_exited(body: Node2D) -> void:
	is_over_box = false
