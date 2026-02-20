extends CharacterBody3D
@onready var cam = $Head/Camera3D
@onready var head = $Head
@onready var useRange = $Head/Camera3D/RayCast3D

@export var bob_freq = 2.0  # Frequência bobbing(velocidade do balanço)
@export var bob_amp = 0.08  # Amplitude bobbing(força/altura do balanço)
var t_bob = 0.0             # Acumulador de tempo contínuo

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var look_dir: Vector2
var camSense = 0.002

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("action"):
		var target = useRange.get_collider()
		print(target.name)
		
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	
	# Define se a câmera deve balançar (andando) ou voltar ao centro (parado)
	var target_cam_pos = Vector3.ZERO
	if is_on_floor() and velocity.length() > 0.1:
		target_cam_pos = _headbob(t_bob)
	else:
		# Reseta o tempo para que o próximo passo comece do zero
		t_bob = 0.0 
	cam.transform.origin = cam.transform.origin.lerp(target_cam_pos, delta * 10.0)


func _unhandled_input(event):
	# Verifica se a entrada é um movimento do mouse
	if event is InputEventMouseMotion:
		# Rotação horizontal: rotaciona o corpo inteiro no eixo Y
		rotate_y(-event.relative.x * camSense)
		
		# Rotação vertical: rotaciona apenas a cabeça no eixo X
		head.rotate_x(-event.relative.y * camSense)
		
		# Limita a visão para cima/baixo para o jogador não virar contorsionista (entre -89 e 89 graus)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	# Balanço vertical usando Seno
	pos.y = sin(time * bob_freq) * bob_amp
	# Balanço horizontal usando Cosseno (dividido por 2 para dar o formato de "infinito" ou "8")
	pos.x = cos(time * bob_freq / 2.0) * bob_amp 
	return pos
