extends RigidBody2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

var is_moving = false
var target_position: Vector2
var force_strength = 150.0
var max_speed = 2000

var conveyor_orientation: Enum.ConveyorOrientation


@export var mail: Enum.ObjectsInScene
var current_mail: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	angular_damp = 10
	linear_damp = 6
	gravity_scale = 0
	
	current_mail = Data.MailItens[Enum.MailKinds.Package]
#
#func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#is_holding = event.pressed
		#if event.pressed:
			#grab_offset = get_global_mouse_position() - global_position
			#is_moving = false
			#linear_velocity = Vector2.ZERO

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
			linear_velocity = Vector2.UP * force_strength
		elif conveyor_orientation == Enum.ConveyorOrientation.Desc and is_holding == false: 
			linear_velocity = Vector2.DOWN * force_strength

func move_to_position(orientation: Enum.ConveyorOrientation):
	is_moving = true
	conveyor_orientation = orientation

func stop_moving():
	is_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_click_down() -> void:
	is_holding = true
	grab_offset = get_global_mouse_position() - global_position
	is_moving = false
	linear_velocity = Vector2.ZERO


func _on_click_up() -> void:
	is_holding = false
