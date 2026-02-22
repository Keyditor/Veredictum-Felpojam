extends RigidBody2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

var is_moving = false
var target_position: Vector2
var conveyor_speed: float
var max_speed = 2000
var mail_roof: float = 200

@export var mail_info: MailItem

var conveyor_orientation: Enum.ConveyorOrientation

@onready var sprite_2d: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var collision_shape_2d_mouse: CollisionShape2D = $Area2D/CollisionShape2D

var is_sent: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	angular_damp = 10
	linear_damp = 6
	gravity_scale = 0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_holding:
		var target = get_global_mouse_position() - grab_offset
		var direction = target - global_position
		
		var strength = 100
		state.linear_velocity = direction * strength
	else:
		state.linear_velocity = Vector2.ZERO
		if state.linear_velocity.length() > max_speed:
			state.linear_velocity = state.linear_velocity.normalized() * max_speed

func _physics_process(delta: float) -> void:
	if is_moving:
		#var direction = target_position - global_position
		#
		#if linear_velocity.length() < 10:
			#is_moving = false
			#linear_velocity = Vector2.ZERO
		#else:
			#apply_central_force(direction.normalized() * force_strength)
			
		if conveyor_orientation == Enum.ConveyorOrientation.Asc and is_holding == false:
			linear_velocity = Vector2.UP * conveyor_speed
		elif conveyor_orientation == Enum.ConveyorOrientation.Desc and is_holding == false: 
			linear_velocity = Vector2.DOWN * conveyor_speed

func move_to_position(orientation: Enum.ConveyorOrientation, speed):
	is_moving = true
	conveyor_orientation = orientation
	conveyor_speed = speed

func stop_moving():
	is_moving = false

func send_mail():
	is_sent = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_sent and global_position.y >= mail_roof:
		Data.add_to_in_scene_mail(self)
		print(Data.in_scene_mail)
		is_sent = false
		
	# Declarar variáveis do Resource
	sprite_2d.texture = mail_info.texture
	collision_shape_2d.shape = mail_info.collider_shape
	collision_shape_2d.position = mail_info.collider_position
	collision_shape_2d_mouse.shape = mail_info.collider_shape
	collision_shape_2d_mouse.position = mail_info.collider_position



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_holding = true
				grab_offset = get_global_mouse_position() - global_position
				is_moving = false
				linear_velocity = Vector2.ZERO
			else:
				is_holding = false
				is_sent = false
