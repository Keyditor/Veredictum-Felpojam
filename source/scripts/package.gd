extends RigidBody2D

var is_holding: bool = false
var is_over_box: bool = false
var grab_offset := Vector2.ZERO

var is_moving: bool = false
var is_on_conveyor: bool = true
var conveyor_speed: float
var max_speed = 2000

var initial_pos: Vector2
var final_pos: Vector2

@export var mails_within: Array = []

var conveyor_orientation: Enum.ConveyorOrientation

@onready var sprite_2d: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_mouse: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	angular_damp = 10
	linear_damp = 6
	gravity_scale = 0
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if global_position == final_pos and not is_holding:
		if conveyor_orientation == Enum.ConveyorOrientation.Asc:
			Data.add_to_in_scene_mail(mails_within)
			animation_player.play("pop_out")
	if is_on_conveyor:
		is_moving = true
	
	if object:
		if object.is_in_group("objects") and is_over_box and not object.is_holding:
			mails_within.append(object.mail_info)
			object.animation_player.play("pop_out")
			animation_player.play("put_inside")
		if object.is_in_group("objects") and is_over_box and object.is_holding:
			object.apply_outline()
		else:
			object.remove_outline()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed: # Impede que a encomenda seja puxada junto com o carimbo
				is_holding = true
				grab_offset = get_global_mouse_position() - global_position
				is_moving = false
				linear_velocity = Vector2.ZERO
			else:
				is_holding = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_over_box = true
	object = body




func _on_area_2d_body_exited(body: Node2D) -> void:
	is_over_box = false
