extends RigidBody2D

var is_holding: bool = false
var grab_offset := Vector2.ZERO

var is_moving: bool = false
var is_on_conveyor: bool = true
var conveyor_speed: float
var max_speed = 2000

var final_pos: Vector2

@export var mail_info: MailItem

var conveyor_orientation: Enum.ConveyorOrientation

@onready var sprite_2d: Sprite2D = $Area2D/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_mouse: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const shader = preload("res://scenes/shaders/mail_object.gdshader") 
var new_material

var information_canvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lock_rotation = true
	angular_damp = 10
	linear_damp = 6
	gravity_scale = 0
	
	information_canvas = get_tree().get_nodes_in_group("work_table")[0].get_node("InformationCanvas")
	animation_player.play("pop_up")
	
	# Criação do material que contém a outline
	new_material = ShaderMaterial.new()
	new_material.shader = shader
	
	## Faz com que a carta seja reconhecida pelo envelope
	#if mail_info.mail_type == Enum.MailTypes.Letter:
		#set_collision_mask_value(5, true)
	#else:
		#set_collision_mask_value(5, false)
		


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
				state.linear_velocity = Vector2.RIGHT * 4000

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


func show_information():
	if mail_info.sender_name != "Player":
		information_canvas.get_node("Panel/TextureRect").texture = mail_info.info
		information_canvas.visible = true
		information_canvas.get_node("Panel/PlayerDocumentation").visible = false
	else:
		information_canvas.get_node("Panel/TextureRect").visible = false
		information_canvas.visible = true
		information_canvas.get_node("Panel/PlayerDocumentation").visible = true
		show_player_documentation()

# Mostrar a própria ficha do jogador
func show_player_documentation():
	
	information_canvas.canvas_animation_player.play("show_player_documentation")

func hide_player_documentation():
	information_canvas.canvas_animation_player.play("hide_player_documentation")
func hide_information():
	information_canvas.visible = false

func apply_outline():
	sprite_2d.material = new_material

func remove_outline():
	sprite_2d.material = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	# Declarar variáveis do Resource
	sprite_2d.texture = mail_info.texture
	collision_shape_2d.shape = mail_info.collider_shape
	collision_shape_2d.position = mail_info.collider_position
	collision_shape_2d.scale = mail_info.scale
	collision_shape_2d.rotation = mail_info.rotation
	collision_shape_2d.skew = mail_info.skew
	
	# Colisor do Click do Mouse
	collision_shape_2d_mouse.shape = mail_info.collider_shape
	collision_shape_2d_mouse.position = mail_info.collider_position
	collision_shape_2d_mouse.scale = mail_info.scale
	collision_shape_2d_mouse.rotation = mail_info.rotation
	collision_shape_2d_mouse.skew = mail_info.skew

	if is_on_conveyor:
		is_moving = true


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
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if mail_info.info or mail_info.sender_name == "Player":
				show_information()
