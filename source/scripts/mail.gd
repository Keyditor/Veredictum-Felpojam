extends RigidBody2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

var is_moving = false
var target_position: Vector2
var conveyor_speed: float
var max_speed = 2000
var mail_roof: float = 200

var initial_pos: Vector2
var final_pos: Vector2

@export var mail_info: MailItem

var conveyor_orientation: Enum.ConveyorOrientation

@onready var sprite_2d: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_mouse: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var information_canvas

var clicked_stamp: bool = false

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
		state.linear_velocity = Vector2.ZERO
		if state.linear_velocity.length() > max_speed:
			state.linear_velocity = state.linear_velocity.normalized() * max_speed

func _physics_process(delta: float) -> void:
	if is_moving:
		if not is_holding:
			position = position.move_toward(final_pos, conveyor_speed * delta)

func move_to_position(orientation: Enum.ConveyorOrientation, speed, final: Vector2):
	is_moving = true
	conveyor_orientation = orientation
	conveyor_speed = speed
	final_pos = final

func stop_moving():
	is_moving = false


func show_information():
	information_canvas.get_node("Panel/TextureRect").texture = mail_info.info
	print(information_canvas.get_node("Panel/TextureRect"))
	information_canvas.visible = true

func hide_information():
	information_canvas.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if global_position == final_pos:
		Data.add_to_in_scene_mail(self)
		print(Data.in_scene_mail)
		
	# Declarar variáveis do Resource
	sprite_2d.texture = mail_info.texture
	collision_shape_2d.shape = mail_info.collider_shape
	collision_shape_2d.position = mail_info.collider_position
	collision_shape_2d_mouse.shape = mail_info.collider_shape
	collision_shape_2d_mouse.position = mail_info.collider_position



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not clicked_stamp: # Impede que a encomenda seja puxada junto com o carimbo
				is_holding = true
				grab_offset = get_global_mouse_position() - global_position
				is_moving = false
				linear_velocity = Vector2.ZERO
			else:
				is_holding = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			show_information()
